import SpriteKit

/// The whole game: tile world, manual AABB physics, enemies, blocks, HUD,
/// touch controls, camera, and win/death sequences.
final class GameScene: SKScene {

    enum State { case playing, dying, flagSequence, walkingToCastle, gameOver, win }

    // MARK: Config

    var level = LevelDef()
    var tileSize: CGFloat = 32
    var state: State = .playing
    var score = 0
    var coinCount = 0
    var lives = 3
    var timeLeft: Double = 400
    private var timeAccum: Double = 0

    static let autopilot = ProcessInfo.processInfo.arguments.contains("-autopilot")

    // MARK: Nodes

    private let worldNode = SKNode()
    private let cameraNode = SKCameraNode()
    private let hudNode = SKNode()
    private let controlsNode = SKNode()
    private var blockNodes: [Int: SKSpriteNode] = [:] // key = row*10000 + col
    private var coinNodes: [SKSpriteNode] = []
    private var scenery: [(node: SKNode, wx: CGFloat, factor: CGFloat)] = []
    private var flagNode: SKSpriteNode!
    private var poleX: CGFloat = 0
    private var flagSequenceT: TimeInterval = 0

    // MARK: Entities

    private var player = Player()
    private var walkers: [Walker] = []
    private var items: [Entity] = []

    // MARK: Input

    var leftHeld = false
    var rightHeld = false
    var jumpHeld = false
    var runHeld = false
    private var jumpQueued = false
    private var touchRoles: [ObjectIdentifier: String] = [:]

    // MARK: HUD labels

    private var scoreLabel: SKLabelNode!
    private var coinLabel: SKLabelNode!
    private var timeLabel: SKLabelNode!
    private var messageLabel: SKLabelNode!
    private var subMessageLabel: SKLabelNode!

    // MARK: Physics timing

    private var lastUpdate: TimeInterval = 0
    private var accumulator: TimeInterval = 0
    private let step: TimeInterval = 1.0 / 120.0
    private var camMinX: CGFloat = 0
    private var autopilotJumpCooldown: TimeInterval = 0
    private var autopilotLastX: CGFloat = 0
    private var autopilotStuckT: TimeInterval = 0

    // MARK: - Setup

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.36, green: 0.58, blue: 0.99, alpha: 1)
        tileSize = size.height / 13.5

        addChild(worldNode)
        camera = cameraNode
        addChild(cameraNode)
        cameraNode.addChild(hudNode)
        cameraNode.addChild(controlsNode)

        buildWorld()
        buildScenery()
        buildFlagpole()
        buildCastle()
        spawnPlayer()
        buildHUD()
        buildControls()

        camMinX = size.width / 2
        cameraNode.position = CGPoint(x: camMinX, y: size.height / 2)

        if !Self.autopilot {
            SoundPlayer.shared.playMusic("overworld")
        } else {
            // Demo mode: drop a mushroom near the end stretch so the
            // self-play showcases the power-up chain before the flag.
            let m = MushroomItem()
            m.world = self
            m.size = CGSize(width: tileSize, height: tileSize)
            m.position = CGPoint(x: tileCenterX(145),
                                 y: tileTop(11) + tileSize)
            m.zPosition = 5
            worldNode.addChild(m)
            items.append(m)
            m.active = true
        }
    }

    // MARK: Coordinate helpers (bottom-left origin; row 14 is ground bottom)

    func col(atX x: CGFloat) -> Int { Int(floor(x / tileSize)) }
    func row(atY y: CGFloat) -> Int { (level.height - 1) - Int(floor(y / tileSize)) }
    func tileLeft(_ c: Int) -> CGFloat { CGFloat(c) * tileSize }
    func tileRight(_ c: Int) -> CGFloat { CGFloat(c + 1) * tileSize }
    func tileTop(_ r: Int) -> CGFloat { CGFloat(level.height - r) * tileSize }
    func tileBottom(_ r: Int) -> CGFloat { CGFloat(level.height - r - 1) * tileSize }
    func tileCenterX(_ c: Int) -> CGFloat { (CGFloat(c) + 0.5) * tileSize }
    func tileCenterY(_ r: Int) -> CGFloat { (CGFloat(level.height - r) - 0.5) * tileSize }

    func isSolid(col: Int, row: Int) -> Bool { level.tile(at: col, row: row).isSolid }

    // MARK: - World construction

    private func blockKey(_ col: Int, _ row: Int) -> Int { row * 10000 + col }

    private func buildWorld() {
        for r in 0 ..< level.height {
            for c in 0 ..< level.width {
                let t = level.grid[r][c]
                guard t != .empty else { continue }
                let node = SKSpriteNode(texture: texture(for: t, col: c, row: r))
                node.texture?.filteringMode = .nearest
                node.size = CGSize(width: tileSize, height: tileSize)
                node.position = CGPoint(x: tileCenterX(c), y: tileCenterY(r))
                node.zPosition = 2
                worldNode.addChild(node)
                blockNodes[blockKey(c, r)] = node
                if t == .questionCoin || t == .questionMushroom {
                    animateQuestion(node)
                }
            }
        }
        // Coins scattered on the map.
        for (c, r) in level.coins {
            let coin = SKSpriteNode(texture: Art.texCoin1)
            coin.texture?.filteringMode = .nearest
            coin.size = CGSize(width: tileSize * 0.9, height: tileSize * 0.9)
            coin.position = CGPoint(x: tileCenterX(c), y: tileCenterY(r))
            coin.zPosition = 3
            coin.run(SKAction.repeatForever(
                PixelArt.animate([Art.texCoin1, Art.texCoin2, Art.texCoin3, Art.texCoin2], timePerFrame: 0.12)))
            worldNode.addChild(coin)
            coinNodes.append(coin)
        }
        // Enemies from spawn list.
        for s in level.spawns {
            let e: Walker = s.kind == .goomba ? Goomba() : Koopa()
            e.world = self
            let h = s.kind == .goomba ? tileSize : tileSize * 1.25
            e.size = CGSize(width: tileSize, height: h)
            e.position = CGPoint(x: tileCenterX(s.col), y: tileTop(13) + h / 2)
            e.zPosition = 6
            worldNode.addChild(e)
            walkers.append(e)
        }
    }

    private func texture(for t: Tile, col: Int, row: Int) -> SKTexture {
        switch t {
        case .ground:
            // Grass cap only on the topmost ground tile of a stack.
            let above = level.tile(at: col, row: row - 1)
            return above.isSolid ? Art.texGroundFill : Art.texGroundTop
        case .brick: return Art.texBrick
        case .questionCoin, .questionMushroom: return Art.texQuestion1
        case .used: return Art.texBlockUsed
        case .stone: return Art.texStone
        case .pipeTopLeft: return Art.texPipeTL
        case .pipeTopRight: return Art.texPipeTR
        case .pipeBodyLeft: return Art.texPipeBL
        case .pipeBodyRight: return Art.texPipeBR
        case .empty: return Art.texBrick
        }
    }

    private func animateQuestion(_ node: SKSpriteNode) {
        node.run(SKAction.repeatForever(
            PixelArt.animate([Art.texQuestion1, Art.texQuestion2, Art.texQuestion3, Art.texQuestion2],
                             timePerFrame: 0.18)))
    }

    private func buildScenery() {
        // Hills, clouds, bushes — children of the camera, repositioned every
        // frame with a parallax factor so they drift slower than the world.
        func add(_ tex: SKTexture, wx: CGFloat, wy: CGFloat, hTiles: CGFloat, factor: CGFloat) {
            let n = SKSpriteNode(texture: tex)
            n.texture?.filteringMode = .nearest
            n.size = CGSize(width: tex.size().width / tex.size().height * tileSize * hTiles,
                            height: tileSize * hTiles)
            n.zPosition = -10
            cameraNode.addChild(n)
            scenery.append((n, wx, factor))
            n.position = CGPoint(x: wx, y: wy - size.height / 2)
        }
        for wx in stride(from: CGFloat(260), to: 5600, by: 640) {
            add(Art.texHill, wx: wx, wy: tileSize * 2 + 40, hTiles: 3.2, factor: 0.75)
        }
        for wx in stride(from: CGFloat(500), to: 5600, by: 900) {
            add(Art.texCloud, wx: wx, wy: tileSize * 11.5, hTiles: 1.6, factor: 0.9)
            add(Art.texCloud, wx: wx + 300, wy: tileSize * 10.2, hTiles: 1.2, factor: 0.92)
        }
        for wx in stride(from: CGFloat(420), to: 5600, by: 1100) {
            add(Art.texBush, wx: wx, wy: tileSize * 2 + 18, hTiles: 1.4, factor: 0.85)
        }
    }

    private func buildFlagpole() {
        poleX = tileCenterX(level.flagpoleCol)
        let poleHeight = tileSize * 9
        let pole = SKSpriteNode(color: UIColor(red: 0.2, green: 0.55, blue: 0.2, alpha: 1),
                                size: CGSize(width: tileSize * 0.12, height: poleHeight))
        pole.anchorPoint = CGPoint(x: 0.5, y: 0)
        pole.position = CGPoint(x: poleX, y: tileTop(13))
        pole.zPosition = 4
        worldNode.addChild(pole)

        let ball = Art.texFlagBall.spriteNode(pixelHeight: tileSize * 0.55)
        ball.position = CGPoint(x: poleX, y: tileTop(13) + poleHeight + tileSize * 0.2)
        ball.zPosition = 4
        worldNode.addChild(ball)

        flagNode = Art.texFlag.spriteNode(pixelHeight: tileSize * 0.55)
        flagNode.anchorPoint = CGPoint(x: 1, y: 0.5)
        flagNode.position = CGPoint(x: poleX - tileSize * 0.1, y: tileTop(13) + poleHeight - tileSize * 0.5)
        flagNode.zPosition = 4
        worldNode.addChild(flagNode)
    }

    private func buildCastle() {
        let castle = Art.texCastle.spriteNode(pixelHeight: tileSize * 5)
        castle.anchorPoint = CGPoint(x: 0.5, y: 0)
        castle.position = CGPoint(x: tileCenterX(level.castleCol), y: tileTop(13))
        castle.zPosition = 1
        worldNode.addChild(castle)
    }

    private func spawnPlayer() {
        player = Player()
        player.world = self
        player.position = CGPoint(x: tileCenterX(level.playerStartCol), y: tileTop(13) + tileSize * 0.55)
        player.zPosition = 8
        worldNode.addChild(player)
        player.hitCeiling = { [weak self] c, r in self?.playerBumped(col: c, row: r) }
    }

    // MARK: - HUD & controls

    private func hudLabel(_ text: String, size: CGFloat) -> SKLabelNode {
        let l = SKLabelNode(fontNamed: "Menlo-Bold")
        l.text = text
        l.fontSize = size
        l.fontColor = .white
        l.horizontalAlignmentMode = .center
        l.verticalAlignmentMode = .top
        l.zPosition = 100
        return l
    }

    private func buildHUD() {
        // Center HUD + controls inside the safe area (keeps the Dynamic
        // Island from overlapping TIME/right controls in landscape).
        let insets = view?.safeAreaInsets ?? .zero
        let cx = (insets.left - insets.right) / 2
        hudNode.position = CGPoint(x: cx, y: 0)
        controlsNode.position = CGPoint(x: cx, y: 0)

        let top = size.height / 2 - 12
        let fs = max(13, tileSize * 0.45)

        func put(_ node: SKLabelNode, _ x: CGFloat, _ y: CGFloat) {
            node.position = CGPoint(x: x, y: y)
            hudNode.addChild(node)
        }

        scoreLabel = hudLabel("000000", size: fs)
        put(scoreLabel, -size.width * 0.32, top)
        coinLabel = hudLabel("x00", size: fs)
        put(coinLabel, -size.width * 0.1, top)
        let worldLabel = hudLabel("WORLD 1-1", size: fs)
        put(worldLabel, size.width * 0.1, top)
        timeLabel = hudLabel("TIME 400", size: fs)
        put(timeLabel, size.width * 0.33, top)

        messageLabel = hudLabel("", size: fs * 2)
        put(messageLabel, 0, tileSize * 2)
        subMessageLabel = hudLabel("", size: fs)
        put(subMessageLabel, 0, tileSize * 0.8)
        refreshHUD()
    }

    private func refreshHUD() {
        scoreLabel.text = String(format: "%06d", score)
        coinLabel.text = String(format: "x%02d", coinCount)
        timeLabel.text = String(format: "TIME %03d", max(0, Int(timeLeft)))
    }

    @discardableResult
    private func makeButton(_ name: String, _ glyph: String, _ pos: CGPoint, _ radius: CGFloat) -> SKNode {
        let container = SKNode()
        container.position = pos
        container.name = name
        let circle = SKShapeNode(circleOfRadius: radius)
        circle.fillColor = UIColor.white.withAlphaComponent(0.30)
        circle.strokeColor = UIColor.white.withAlphaComponent(0.65)
        circle.lineWidth = 2
        circle.name = name
        let label = SKLabelNode(fontNamed: "Menlo-Bold")
        label.text = glyph
        label.fontSize = radius * 0.9
        label.fontColor = UIColor.white.withAlphaComponent(0.9)
        label.verticalAlignmentMode = .center
        label.name = name
        container.addChild(circle)
        container.addChild(label)
        controlsNode.addChild(container)
        return container
    }

    private func buildControls() {
        let insets = view?.safeAreaInsets ?? .zero
        let cx = (insets.left - insets.right) / 2
        let r = tileSize * 1.05
        let bottomY = -size.height / 2 + insets.bottom + r + 10
        let leftX = -size.width / 2 + insets.left + r + 16 - cx
        let rightX = size.width / 2 - insets.right - r - 16 - cx
        makeButton("btn_left", "<", CGPoint(x: leftX, y: bottomY), r)
        makeButton("btn_right", ">", CGPoint(x: leftX + r * 2.3, y: bottomY), r)
        makeButton("btn_run", "B", CGPoint(x: rightX - r * 2.3, y: bottomY), r)
        makeButton("btn_jump", "A", CGPoint(x: rightX, y: bottomY), r)
        controlsNode.alpha = Self.autopilot ? 0 : 1
    }

    // MARK: - Input

    private func role(at point: CGPoint) -> String? {
        let nodes = controlsNode.nodes(at: point)
        return nodes.compactMap { $0.name }.first { $0.hasPrefix("btn_") }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let p = t.location(in: controlsNode)
            if let r = role(at: p) {
                touchRoles[ObjectIdentifier(t)] = r
                applyRole(r, down: true)
            } else if state == .gameOver || state == .win {
                resetToTitle()
            }
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches {
            let id = ObjectIdentifier(t)
            let p = t.location(in: controlsNode)
            let newRole = role(at: p)
            let oldRole = touchRoles[id]
            if newRole != oldRole {
                if let o = oldRole { applyRole(o, down: false) }
                if let n = newRole { applyRole(n, down: true) }
                touchRoles[id] = newRole
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { releaseTouch(t) }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { releaseTouch(t) }
    }

    private func releaseTouch(_ t: UITouch) {
        let id = ObjectIdentifier(t)
        if let r = touchRoles[id] {
            applyRole(r, down: false)
            touchRoles.removeValue(forKey: id)
        }
    }

    private func applyRole(_ role: String, down: Bool) {
        switch role {
        case "btn_left": leftHeld = down
        case "btn_right": rightHeld = down
        case "btn_jump":
            if down && !jumpHeld { jumpQueued = true }
            jumpHeld = down
        case "btn_run": runHeld = down
        default: break
        }
    }

    /// Keyboard input from GameViewController.
    func keyChanged(_ key: String, down: Bool) {
        switch key {
        case "left": leftHeld = down
        case "right": rightHeld = down
        case "jump":
            if down && !jumpHeld { jumpQueued = true }
            jumpHeld = down
        case "run": runHeld = down
        default: break
        }
    }

    // MARK: - Autopilot (demo/testing: plays itself)

    private func driveAutopilot() {
        leftHeld = false
        rightHeld = true
        runHeld = true
        // Chase a live mushroom that slipped behind us.
        if let m = items.compactMap({ $0 as? MushroomItem }).first(where: { $0.active }) {
            if m.position.x < player.position.x - tileSize * 0.5 {
                rightHeld = false
                leftHeld = true
            }
        }

        autopilotJumpCooldown -= step
        if autopilotJumpCooldown > 0 { return }

        // Look ahead at foot level and head level.
        let feetY = player.bottom + 2
        let aheadX1 = player.right + tileSize * 0.9
        let aheadX2 = player.right + tileSize * 1.8
        let c1 = col(atX: aheadX1)
        let c2 = col(atX: aheadX2)
        let footRow = row(atY: feetY)
        let headRow = row(atY: player.top - 2)

        var wantJump = false
        // Wall ahead at foot or head height.
        if isSolid(col: c1, row: footRow) || isSolid(col: c1, row: headRow) {
            wantJump = true
        }
        // Gap ahead: no ground in the next 1.5 tiles below feet.
        if player.onGround {
            var groundAhead = false
            for c in c1 ... c2 + 1 {
                for r in footRow ... footRow + 2 {
                    if r < level.height, isSolid(col: c, row: r) { groundAhead = true }
                }
            }
            if !groundAhead { wantJump = true }
        }
        // Enemy close ahead at our height: jump so we clear or land on it.
        for w in walkers where w.alive && abs(w.position.y - player.position.y) < tileSize * 1.6 {
            let dx = w.position.x - player.position.x
            if dx > 0 && dx < tileSize * 2.5 { wantJump = true }
        }
        // Brick/question block 3-5 rows above feet within ~1.5 tiles: bump it.
        for dr in 3 ... 5 {
            for c in c1 ... c1 + 1 {
                let r = footRow - dr
                if r >= 0, isSolid(col: c, row: r) { wantJump = true }
            }
        }
        // Stuck detector: hammered into a wall without moving.
        if abs(player.position.x - autopilotLastX) < 1, player.onGround {
            autopilotStuckT += step
            if autopilotStuckT > 0.25 { wantJump = true }
        } else {
            autopilotStuckT = 0
        }
        autopilotLastX = player.position.x

        if wantJump {
            jumpQueued = true
            jumpHeld = true
            autopilotJumpCooldown = 0.3
        } else if player.onGround && autopilotJumpCooldown <= 0 {
            jumpHeld = false
        }
    }

    // MARK: - Block interaction

    private func playerBumped(col: Int, row: Int) {
        let t = level.grid[row][col]
        switch t {
        case .questionCoin:
            usedBlock(col: col, row: row)
            spawnPoppedCoin(col: col, row: row)
            addCoin(200)
        case .questionMushroom:
            usedBlock(col: col, row: row)
            spawnMushroom(col: col, row: row)
            SoundPlayer.shared.play("powerup")
        case .brick:
            if player.form == .big {
                breakBrick(col: col, row: row)
            } else {
                bumpNode(col: col, row: row)
                SoundPlayer.shared.play("bump", volume: 0.7)
            }
        default:
            SoundPlayer.shared.play("bump", volume: 0.35)
        }
        // Enemies standing on a bumped block die.
        for w in walkers where w.alive && w.onGround {
            if self.col(atX: w.position.x) == col, self.row(atY: w.bottom - 2) == row {
                killByBlock(w)
            }
        }
    }

    private func usedBlock(col: Int, row: Int) {
        level.grid[row][col] = .used
        if let n = blockNodes[blockKey(col, row)] {
            n.removeAllActions()
            n.texture = Art.texBlockUsed
            bumpNode(col: col, row: row)
        }
    }

    private func bumpNode(col: Int, row: Int) {
        guard let n = blockNodes[blockKey(col, row)] else { return }
        let h = tileSize * 0.28
        n.run(SKAction.sequence([
            SKAction.moveBy(x: 0, y: h, duration: 0.07),
            SKAction.moveBy(x: 0, y: -h, duration: 0.09),
        ]))
    }

    private func breakBrick(col: Int, row: Int) {
        level.grid[row][col] = .empty
        guard let n = blockNodes.removeValue(forKey: blockKey(col, row)) else { return }
        SoundPlayer.shared.play("break")
        score += 50
        // Four brick chunks fly out.
        let chunk = SKTexture(rect: CGRect(x: 0, y: 0, width: 0.5, height: 0.5), in: Art.texBrick)
        chunk.filteringMode = .nearest
        for (dx, dy) in [(-1.0, 1.0), (1.0, 1.0), (-1.0, 0.55), (1.0, 0.55)] {
            let c = SKSpriteNode(texture: chunk)
            c.size = CGSize(width: tileSize * 0.5, height: tileSize * 0.5)
            c.position = n.position
            c.zPosition = 7
            worldNode.addChild(c)
            let vx = dx * tileSize * 3.2
            let vy = dy * tileSize * 9
            c.run(SKAction.sequence([
                SKAction.group([
                    SKAction.moveBy(x: vx * 0.5, y: vy * 0.5, duration: 0.28),
                    SKAction.rotate(byAngle: dx > 0 ? 3 : -3, duration: 0.3),
                ]),
                SKAction.moveBy(x: vx * 0.6, y: -vy * 1.2, duration: 0.4),
                SKAction.removeFromParent(),
            ]))
        }
        n.removeFromParent()
    }

    private func killByBlock(_ w: Walker) {
        w.alive = false
        w.vel = CGPoint(x: w.dir * 90, y: 480)
        w.zRotation = .pi
        w.removeAllActions()
        // Falls through world; removed when below screen.
    }

    private func spawnPoppedCoin(col: Int, row: Int) {
        let coin = SKSpriteNode(texture: Art.texCoin1)
        coin.texture?.filteringMode = .nearest
        coin.size = CGSize(width: tileSize * 0.9, height: tileSize * 0.9)
        coin.position = CGPoint(x: tileCenterX(col), y: tileTop(row) + tileSize * 0.2)
        coin.zPosition = 7
        worldNode.addChild(coin)
        coin.run(SKAction.repeatForever(
            PixelArt.animate([Art.texCoin1, Art.texCoin2, Art.texCoin3, Art.texCoin2], timePerFrame: 0.07)))
        coin.run(SKAction.sequence([
            SKAction.moveBy(x: 0, y: tileSize * 1.6, duration: 0.22),
            SKAction.moveBy(x: 0, y: -tileSize * 1.4, duration: 0.16),
            SKAction.removeFromParent(),
        ]))
        popup("+200", at: CGPoint(x: tileCenterX(col), y: tileTop(row) + tileSize))
    }

    private func spawnMushroom(col: Int, row: Int) {
        let m = MushroomItem()
        m.world = self
        m.size = CGSize(width: tileSize, height: tileSize)
        m.position = CGPoint(x: tileCenterX(col), y: tileCenterY(row))
        m.zPosition = 5
        worldNode.addChild(m)
        items.append(m)
        // Rise out of the block, then walk.
        m.run(SKAction.sequence([
            SKAction.moveBy(x: 0, y: tileSize, duration: 0.5),
            SKAction.run { m.active = true },
        ]))
    }

    private func popup(_ text: String, at p: CGPoint) {
        let l = hudLabel(text, size: max(11, tileSize * 0.38))
        l.position = p
        l.zPosition = 20
        worldNode.addChild(l)
        l.run(SKAction.sequence([
            SKAction.moveBy(x: 0, y: tileSize * 1.2, duration: 0.6),
            SKAction.removeFromParent(),
        ]))
    }

    private func addCoin(_ points: Int) {
        coinCount += 1
        score += points
        SoundPlayer.shared.play("coin", volume: 0.7)
        if coinCount >= 100 {
            coinCount = 0
            lives += 1
            SoundPlayer.shared.play("oneup")
        }
        refreshHUD()
    }

    // MARK: - Death / win

    private func killPlayer() {
        guard state == .playing else { return }
        player.dead = true
        player.frozen = true
        state = .dying
        SoundPlayer.shared.stopMusic()
        SoundPlayer.shared.play("death")
        player.vel = CGPoint(x: 0, y: 560)
        player.zPosition = 30
    }

    private func finishDeath() {
        lives -= 1
        if lives <= 0 {
            state = .gameOver
            showMessage("GAME OVER", sub: "tap to try again")
            SoundPlayer.shared.play("gameover")
        } else {
            respawn()
        }
    }

    private func respawn() {
        // Reset player + camera; enemies/items stay (classic keeps level state).
        player.removeFromParent()
        spawnPlayer()
        state = .playing
        camMinX = size.width / 2
        cameraNode.position.x = camMinX
        timeLeft = 400
        SoundPlayer.shared.playMusic("overworld")
    }

    private func showMessage(_ msg: String, sub: String) {
        messageLabel.text = msg
        subMessageLabel.text = sub
    }

    private func clearMessage() {
        messageLabel.text = ""
        subMessageLabel.text = ""
    }

    /// Enter-key restart hook from GameViewController.
    func requestReset() {
        if state == .gameOver || state == .win { resetToTitle() }
    }

    private func resetToTitle() {
        let scene = TitleScene(size: size)
        scene.scaleMode = .resizeFill
        view?.presentScene(scene, transition: .fade(withDuration: 0.4))
    }

    private func startFlagSequence() {
        guard state == .playing else { return }
        state = .flagSequence
        flagSequenceT = 0
        player.frozen = true
        player.vel = .zero
        player.xScale = abs(player.xScale)
        SoundPlayer.shared.stopMusic()
        SoundPlayer.shared.play("flagpole")
    }

    // MARK: - Update loop

    override func update(_ currentTime: TimeInterval) {
        if lastUpdate == 0 { lastUpdate = currentTime }
        var frame = currentTime - lastUpdate
        lastUpdate = currentTime
        frame = min(frame, 0.1)
        accumulator += frame

        while accumulator >= step {
            fixedUpdate(step, now: currentTime)
            accumulator -= step
        }

        updateCameraAndScenery()
    }

    private func fixedUpdate(_ dt: TimeInterval, now: TimeInterval) {
        switch state {
        case .playing:
            if Self.autopilot { driveAutopilot() }
            player.inputDir = (rightHeld ? 1 : 0) + (leftHeld ? -1 : 0)
            player.running = runHeld
            if jumpQueued {
                player.wantsJump = true
                jumpQueued = false
            }
            player.jumpHeld = jumpHeld
            player.updatePlayer(dt: dt, currentTime: now)
            clampPlayerToCamera()

            for w in walkers { updateEnemy(w, dt: dt, now: now) }
            for i in items { (i as? MushroomItem)?.updateItem(dt: dt) }
            cleanupDead(dt: dt)
            checkInteractions(now: now)
            checkFellInPit()
            checkFlagpole()

            // Timer.
            timeAccum += dt
            if timeAccum >= 1 {
                timeAccum -= 1
                timeLeft -= 1
                refreshHUD()
                if timeLeft <= 0 { killPlayer() }
            }

        case .dying:
            // Death arc: pop up, fall through the world.
            player.position.y += player.vel.y * dt
            player.vel.y -= Player.gravityFall * dt
            if player.position.y < -tileSize * 2 { finishDeath() }

        case .flagSequence:
            flagSequenceT += dt
            // Slide down the pole while the flag drops.
            player.position.x = poleX - player.size.width * 0.2
            player.position.y -= 200 * dt
            flagNode.position.y -= 230 * dt
            if player.position.y <= tileTop(13) + player.size.height / 2 {
                player.position.y = tileTop(13) + player.size.height / 2
                player.frozen = false
                state = .walkingToCastle
                score += Int(max(0, timeLeft)) * 10
                refreshHUD()
            }

        case .walkingToCastle:
            player.inputDir = 1
            player.running = false
            player.updatePlayer(dt: dt, currentTime: now)
            player.position.x = min(player.position.x, tileCenterX(level.castleCol) + tileSize * 0.8)
            if player.position.x >= tileCenterX(level.castleCol) + tileSize * 0.8 {
                player.isHidden = true
                state = .win
                showMessage("COURSE CLEAR!", sub: "score \(score)  ·  tap to play again")
            }

        case .gameOver, .win:
            break
        }
    }

    private func updateEnemy(_ w: Walker, dt: TimeInterval, now: TimeInterval) {
        // Only simulate living enemies near the camera (classic activation
        // distance). Dead walkers are handled by cleanupDead.
        guard w.alive else { return }
        let camX = cameraNode.position.x
        if w.position.x > camX + size.width * 0.8 || w.position.x < camX - size.width { return }
        if let k = w as? Koopa {
            k.updateKoopa(dt: dt, currentTime: now)
        } else {
            w.updateWalker(dt: dt)
        }
    }

    private func cleanupDead(dt: TimeInterval) {
        for w in walkers where !w.alive {
            if let g = w as? Goomba, g.zRotation == 0 {
                // Squashed: linger, then remove.
                g.squashTimer += dt
                if g.squashTimer > 0.7 { w.removeFromParent() }
            } else {
                // Killed by block: let it arc off-screen.
                w.position.x += w.vel.x * dt
                w.position.y += w.vel.y * dt
                w.vel.y -= 1900 * dt
                if w.position.y < -tileSize { w.removeFromParent() }
            }
        }
        walkers.removeAll { $0.parent == nil }
    }

    private func checkInteractions(now: TimeInterval) {
        guard !player.dead else { return }
        let pL = player.left, pR = player.right, pB = player.bottom, pT = player.top

        // Enemies.
        for w in walkers where w.alive {
            let eL = w.left, eR = w.right, eB = w.bottom, eT = w.top
            guard pR > eL, pL < eR, pT > eB, pB < eT else { continue }

            let stomping = player.vel.y < -40 && pB > eT - tileSize * 0.45
            if let k = w as? Koopa {
                switch k.state {
                case .walking:
                    if stomping {
                        k.stomp()
                        bounce()
                        score += 100
                        popup("+100", at: w.position)
                    } else if player.hurt(currentTime: now) {
                        if player.dead { killPlayer() }
                    }
                case .shell:
                    // Touching a still shell kicks it away.
                    k.kick(fromRight: player.position.x > w.position.x)
                    score += 100
                case .sliding:
                    if stomping {
                        k.stomp()
                        bounce()
                    } else if player.hurt(currentTime: now) {
                        if player.dead { killPlayer() }
                    }
                }
            } else {
                if stomping {
                    (w as? Goomba)?.squash()
                    bounce()
                    score += 100
                    SoundPlayer.shared.play("stomp")
                    popup("+100", at: w.position)
                } else if player.hurt(currentTime: now) {
                    if player.dead { killPlayer() }
                }
            }
        }

        // Sliding shells kill other walkers.
        for k in walkers.compactMap({ $0 as? Koopa }) where k.state == .sliding {
            for w in walkers where w !== k && w.alive {
                if abs(w.position.x - k.position.x) < tileSize, abs(w.position.y - k.position.y) < tileSize {
                    killByBlock(w)
                    score += 100
                }
            }
        }

        // Items.
        for i in items {
            guard i.parent != nil else { continue }
            if pR > i.left, pL < i.right, pT > i.bottom, pB < i.top {
                if i is MushroomItem {
                    if player.form == .small {
                        player.grow()
                    } else {
                        score += 1000
                        popup("+1000", at: i.position)
                    }
                    i.removeFromParent()
                }
            }
        }
        items.removeAll { $0.parent == nil }

        // Map coins.
        for c in coinNodes where c.parent != nil {
            if abs(c.position.x - player.position.x) < tileSize * 0.6,
               abs(c.position.y - player.position.y) < tileSize * 0.9 {
                c.removeFromParent()
                addCoin(200)
                popup("+200", at: c.position)
            }
        }
        coinNodes.removeAll { $0.parent == nil }
    }

    private func bounce() {
        player.vel.y = jumpHeld ? 520 : 360
        player.onGround = false
    }

    private func checkFellInPit() {
        if state == .playing, player.position.y < -tileSize * 0.5 {
            killPlayer()
        }
    }

    private func checkFlagpole() {
        guard state == .playing else { return }
        if player.right >= poleX - 2 {
            startFlagSequence()
        }
    }

    private func clampPlayerToCamera() {
        // Invisible wall at the left edge of the screen (classic rule).
        let leftEdge = cameraNode.position.x - size.width / 2
        if player.left < leftEdge {
            player.position.x = leftEdge + player.size.width / 2 - player.size.width * player.insetX
            if player.vel.x < 0 { player.vel.x = 0 }
        }
        if player.position.x < player.size.width / 2 {
            player.position.x = player.size.width / 2
            if player.vel.x < 0 { player.vel.x = 0 }
        }
    }

    private func updateCameraAndScenery() {
        guard let cam = camera else { return }
        let worldWidth = CGFloat(level.width) * tileSize
        let target = player.position.x + size.width * 0.12
        var camX = max(camMinX, target)
        camX = min(camX, worldWidth - size.width / 2)
        camMinX = max(camMinX, camX) // camera never scrolls back left
        cam.position.x = camX

        for (node, wx, factor) in scenery {
            node.position.x = wx - camX * factor
        }
    }
}
