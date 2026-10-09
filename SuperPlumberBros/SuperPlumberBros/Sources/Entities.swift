import SpriteKit

/// Axis-separated AABB-vs-tile physics. Entities move horizontally, resolve
/// wall collisions, then move vertically and resolve floor/ceiling. This is
/// the classic platformer approach: deterministic, no tunneling, clean
/// head-bumps.
class Entity: SKSpriteNode {
    var vel = CGPoint.zero
    var onGround = false
    var hitCeiling: ((Int, Int) -> Void)? // (col,row) bumped
    var removeOffscreen = true
    /// Inset (fraction of size) trimmed from each side for collision.
    var insetX: CGFloat = 0.08
    var insetTop: CGFloat = 0.0
    var insetBottom: CGFloat = 0.0

    weak var world: GameScene?

    var tileSize: CGFloat { world?.tileSize ?? 32 }

    /// Collision box edges in scene coordinates.
    var left: CGFloat { position.x - size.width / 2 + size.width * insetX }
    var right: CGFloat { position.x + size.width / 2 - size.width * insetX }
    var top: CGFloat { position.y + size.height / 2 - size.height * insetTop }
    var bottom: CGFloat { position.y - size.height / 2 + size.height * insetBottom }

    func integrate(dt: CGFloat, gravity: CGFloat) {
        vel.y -= gravity * dt
        vel.y = max(vel.y, -1100)

        // --- Horizontal ---
        var newX = position.x + vel.x * dt
        position.x = newX
        if vel.x > 0 {
            let col = world!.col(atX: right)
            let (r0, r1) = rowSpan()
            for r in r0 ... r1 where world!.isSolid(col: col, row: r) {
                position.x = world!.tileLeft(col) - size.width / 2 + size.width * insetX
                vel.x = 0
                hitWall()
                break
            }
        } else if vel.x < 0 {
            let col = world!.col(atX: left)
            let (r0, r1) = rowSpan()
            for r in r0 ... r1 where world!.isSolid(col: col, row: r) {
                position.x = world!.tileRight(col) + size.width / 2 - size.width * insetX
                vel.x = 0
                hitWall()
                break
            }
        }
        newX = position.x

        // --- Vertical ---
        var newY = position.y + vel.y * dt
        position.y = newY
        onGround = false
        let c0 = world!.col(atX: left)
        let c1 = world!.col(atX: right)
        if vel.y <= 0 {
            let row = world!.row(atY: bottom)
            for c in c0 ... c1 where world!.isSolid(col: c, row: row) {
                position.y = world!.tileTop(row) + size.height / 2 - size.height * insetBottom
                vel.y = 0
                onGround = true
                break
            }
        } else {
            let row = world!.row(atY: top)
            for c in c0 ... c1 where world!.isSolid(col: c, row: row) {
                position.y = world!.tileBottom(row) - size.height / 2 + size.height * insetTop
                vel.y = 0
                hitCeiling?(c, row)
                break
            }
        }
        newY = position.y
        _ = newX; _ = newY
    }

    func hitWall() {}

    private func rowSpan() -> (Int, Int) {
        // Rows the entity's feet-to-head spans, biased so standing just below a
        // tile edge doesn't count the row above.
        let r0 = world!.row(atY: bottom + 1)
        let r1 = world!.row(atY: top - 1)
        return (min(r0, r1), max(r0, r1))
    }
}

// MARK: - Player

enum PlayerForm { case small, big }

final class Player: Entity {
    var form: PlayerForm = .small
    var facing: CGFloat = 1 // 1 right, -1 left
    var invincibleUntil: TimeInterval = 0
    var running = false
    var wantsJump = false
    var jumpHeld = false
    var dead = false
    var frozen = false // level-end sequence owns the player
    private var animTime: TimeInterval = 0
    private var coyoteUntil: TimeInterval = 0
    private var jumpBufferUntil: TimeInterval = 0
    private var now: TimeInterval = 0

    static let walkAccel: CGFloat = 1400
    static let runAccel: CGFloat = 2100
    static let skidDecel: CGFloat = 2600
    static let releaseDecel: CGFloat = 3400
    static let walkMax: CGFloat = 190
    static let runMax: CGFloat = 330
    static let jumpVel: CGFloat = 640
    static let gravity: CGFloat = 1900
    static let gravityFall: CGFloat = 2600
    static let coyoteTime: TimeInterval = 0.09
    static let jumpBuffer: TimeInterval = 0.12

    override var insetX: CGFloat {
        get { form == .big ? 0.14 : 0.12 }
        set {}
    }

    init() {
        super.init(texture: Art.texPlayerIdle, color: .clear, size: .zero)
        applyTexture()
    }

    required init?(coder: NSCoder) { fatalError() }

    /// Big Mario is 2 tiles tall; small is 1.
    var pixelHeightTiles: CGFloat { form == .big ? 2 : 1 }

    func applyTexture() {
        let h = tileSize * pixelHeightTiles
        let tex = currentTexture()
        let aspect = tex.size().width / tex.size().height
        size = CGSize(width: h * aspect, height: h)
        texture = tex
        xScale = abs(xScale) * facing
    }

    private func currentTexture() -> SKTexture {
        if dead { return Art.texPlayerDead }
        let moving = abs(vel.x) > 10
        let skidding = moving && ((vel.x > 0) != (facing > 0)) && onGround && (inputDir != 0)
        let big = form == .big
        if !onGround { return big ? Art.texPlayerBigJump : Art.texPlayerJump }
        if skidding { return big ? Art.texPlayerBigSkid : Art.texPlayerSkid }
        if moving {
            let phase = Int(animTime * 12) % 2
            if big { return phase == 0 ? Art.texPlayerBigRun1 : Art.texPlayerBigRun2 }
            return phase == 0 ? Art.texPlayerRun1 : Art.texPlayerRun2
        }
        return big ? Art.texPlayerBigIdle : Art.texPlayerIdle
    }

    var inputDir: CGFloat = 0 // -1, 0, 1 from controls/autopilot

    func updatePlayer(dt: CGFloat, currentTime: TimeInterval) {
        now = currentTime
        animTime += dt
        if onGround { coyoteUntil = now + Self.coyoteTime }

        guard !frozen else {
            vel.x = 0
            integrate(dt: dt, gravity: Self.gravityFall)
            return
        }

        let accel = running ? Self.runAccel : Self.walkAccel
        let maxSpd = running ? Self.runMax : Self.walkMax

        if inputDir != 0 {
            if vel.x != 0 && (vel.x > 0) != (inputDir > 0) {
                vel.x += inputDir * Self.skidDecel * dt
                if (vel.x > 0) == (inputDir > 0) { vel.x = inputDir * 20 }
            } else {
                vel.x += inputDir * accel * dt
            }
            vel.x = max(-maxSpd, min(maxSpd, vel.x))
            facing = inputDir > 0 ? 1 : -1
        } else {
            let s = vel.x > 0 ? CGFloat(1) : -1
            vel.x -= s * Self.releaseDecel * dt
            if vel.x * s < 0 { vel.x = 0 }
        }

        // Jump: buffered press + coyote + variable height.
        if wantsJump {
            wantsJump = false
            jumpBufferUntil = now + Self.jumpBuffer
        }
        if now < jumpBufferUntil && (onGround || now < coyoteUntil) {
            vel.y = Self.jumpVel * (running ? 1.06 : 1.0)
            onGround = false
            coyoteUntil = 0
            jumpBufferUntil = 0
            SoundPlayer.shared.play(form == .big ? "jump_big" : "jump_small", volume: 0.7)
        }

        let g = (vel.y > 0 && jumpHeld) ? Self.gravity : Self.gravityFall
        integrate(dt: dt, gravity: g)

        applyTexture()

        // Invincibility blink.
        if now < invincibleUntil {
            alpha = Int(now * 14) % 2 == 0 ? 0.35 : 0.85
        } else {
            alpha = 1
        }
    }

    func grow() {
        guard form == .small else { return }
        form = .big
        position.y += tileSize * 0.5
        applyTexture()
        SoundPlayer.shared.play("grow")
    }

    /// Returns true if the hit connected (player was not invincible).
    func hurt(currentTime: TimeInterval) -> Bool {
        guard currentTime >= invincibleUntil else { return false }
        if form == .big {
            form = .small
            invincibleUntil = currentTime + 2.0
            position.y -= tileSize * 0.25
            applyTexture()
            SoundPlayer.shared.play("shrink")
            return true
        }
        dead = true
        return true
    }
}

// MARK: - Enemies

class Walker: Entity {
    var dir: CGFloat = -1
    var moveSpeed: CGFloat = 55
    var alive = true
    var squashTimer: TimeInterval = 0
    /// Brief window after being kicked during which the shell can't hit the kicker.
    var contactGraceUntil: TimeInterval = 0

    override func hitWall() { dir = -dir }

    func updateWalker(dt: CGFloat) {
        if !alive { return }
        vel.x = dir * moveSpeed
        integrate(dt: dt, gravity: 1900)
        xScale = dir > 0 ? abs(xScale) : -abs(xScale)
    }
}

final class Goomba: Walker {
    private var animT: TimeInterval = 0

    init() {
        super.init(texture: Art.texGoomba1, color: .clear, size: .zero)
        moveSpeed = 42
        insetX = 0.06
    }

    required init?(coder: NSCoder) { fatalError() }

    override func updateWalker(dt: CGFloat) {
        animT += dt
        if !alive {
            return // handled by scene after squashTimer
        }
        super.updateWalker(dt: dt)
        let phase = Int(animT * 8) % 2
        texture = phase == 0 ? Art.texGoomba1 : Art.texGoomba2
        size = CGSize(width: tileSize, height: tileSize)
    }

    func squash() {
        alive = false
        vel = .zero
        let oldH = size.height
        texture = Art.texGoombaSquash
        size = CGSize(width: tileSize, height: tileSize * 0.55)
        position.y -= (oldH - size.height) / 2 // keep feet on the ground
    }
}

enum KoopaState { case walking, shell, sliding }

final class Koopa: Walker {
    var state: KoopaState = .walking
    private var animT: TimeInterval = 0
    private var shellWake: TimeInterval = 0
    private var now: TimeInterval = 0

    init() {
        super.init(texture: Art.texKoopa1, color: .clear, size: .zero)
        moveSpeed = 36
        insetX = 0.06
    }

    required init?(coder: NSCoder) { fatalError() }

    func updateKoopa(dt: CGFloat, currentTime: TimeInterval) {
        now = currentTime
        animT += dt
        switch state {
        case .walking:
            super.updateWalker(dt: dt)
            let phase = Int(animT * 7) % 2
            setHeight(tileSize * 1.25)
            texture = phase == 0 ? Art.texKoopa1 : Art.texKoopa2
        case .shell:
            vel.x = 0
            integrate(dt: dt, gravity: 1900)
            // Blink faster as wake-up approaches.
            let remain = shellWake - now
            if remain < 2, Int(animT * 10) % 2 == 0 {
                texture = Art.texKoopa1
            } else {
                texture = Art.texKoopaShell
            }
            if remain <= 0 { revive() }
            setHeight(tileSize * 0.9)
        case .sliding:
            moveSpeed = 380
            super.updateWalker(dt: dt)
            xScale = abs(xScale) // shell doesn't flip while sliding
            texture = Art.texKoopaShell
            setHeight(tileSize * 0.9)
            zRotation += vel.x * dt * 0.02
        }
    }

    private func setHeight(_ h: CGFloat) {
        guard abs(size.height - h) > 0.01 else { return }
        let delta = size.height - h
        size = CGSize(width: tileSize, height: h)
        position.y -= delta / 2 // keep feet planted
    }

    /// Walking or sliding -> retreats into a still shell.
    func stomp() {
        guard state != .shell else { return }
        state = .shell
        moveSpeed = 0
        vel = .zero
        shellWake = now + 8
        zRotation = 0
        SoundPlayer.shared.play("stomp", volume: 0.8)
    }

    func kick(fromRight: Bool) {
        state = .sliding
        dir = fromRight ? -1 : 1
        shellWake = now + 8
        SoundPlayer.shared.play("kick")
    }

    private func revive() {
        state = .walking
        dir = -1
        moveSpeed = 36
        zRotation = 0
    }
}

// MARK: - Items

final class MushroomItem: Entity {
    var dir: CGFloat = 1
    var active = false

    init() {
        super.init(texture: Art.texMushroom, color: .clear, size: .zero)
        insetX = 0.05
    }

    required init?(coder: NSCoder) { fatalError() }

    func updateItem(dt: CGFloat) {
        guard active else { return }
        vel.x = dir * 70
        integrate(dt: dt, gravity: 1900)
    }

    override func hitWall() { dir = -dir }
}
