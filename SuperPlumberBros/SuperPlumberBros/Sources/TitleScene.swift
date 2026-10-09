import SpriteKit

/// Title screen: logo, ground strip, blinking prompt. Tap or any key to start.
final class TitleScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 0.36, green: 0.58, blue: 0.99, alpha: 1)
        let tileSize = size.height / 13.5

        // Ground strip.
        for i in 0 ... Int(size.width / tileSize) + 1 {
            let t = SKSpriteNode(texture: Art.texGroundTop)
            t.texture?.filteringMode = .nearest
            t.size = CGSize(width: tileSize, height: tileSize)
            t.position = CGPoint(x: tileSize * (CGFloat(i) + 0.5), y: tileSize * 1.5)
            addChild(t)
        }

        func label(_ text: String, _ fontSize: CGFloat, _ y: CGFloat, color: UIColor = .white) -> SKLabelNode {
            let l = SKLabelNode(fontNamed: "Menlo-Bold")
            l.text = text
            l.fontSize = fontSize
            l.fontColor = color
            l.position = CGPoint(x: self.size.width / 2, y: y)
            addChild(l)
            return l
        }

        // Logo shadow + text.
        let titleSize = min(64, size.width / 10)
        let shadow = label("SUPER", titleSize, size.height * 0.68, color: .black)
        shadow.position.x += 3
        shadow.position.y -= 3
        shadow.zPosition = -1
        let title = label("SUPER", titleSize, size.height * 0.68)
        title.fontColor = UIColor(red: 1, green: 0.84, blue: 0.2, alpha: 1)
        let sub = label("PLUMBER BROS", titleSize * 0.6, size.height * 0.56)
        sub.fontColor = .white

        // A pipe + the hero standing next to it.
        let pipeL = SKSpriteNode(texture: Art.texPipeTL)
        pipeL.texture?.filteringMode = .nearest
        let pipeR = SKSpriteNode(texture: Art.texPipeTR)
        pipeR.texture?.filteringMode = .nearest
        for (i, p) in [pipeL, pipeR].enumerated() {
            p.size = CGSize(width: tileSize, height: tileSize)
            p.position = CGPoint(x: size.width / 2 - tileSize * 7 + CGFloat(i) * tileSize,
                                 y: tileSize * 2.5)
            addChild(p)
        }
        let hero = SKSpriteNode(texture: Art.texPlayerIdle)
        hero.texture?.filteringMode = .nearest
        hero.size = CGSize(width: tileSize, height: tileSize)
        hero.position = CGPoint(x: size.width / 2 + tileSize * 5.5, y: tileSize * 2.5)
        addChild(hero)

        // Blinking prompt.
        let prompt = label("TAP TO START", max(18, tileSize * 0.55), size.height * 0.28)
        prompt.run(SKAction.repeatForever(SKAction.sequence([
            SKAction.fadeOut(withDuration: 0.5),
            SKAction.fadeIn(withDuration: 0.5),
        ])))

        let controls = label("< > move    B run    A jump", max(12, tileSize * 0.32), size.height * 0.21)
        controls.fontColor = UIColor.white.withAlphaComponent(0.85)

        // Demo/testing mode: skip straight into the game.
        if GameScene.autopilot {
            run(SKAction.sequence([SKAction.wait(forDuration: 0.6),
                                   SKAction.run { [weak self] in self?.startGame() }]))
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        startGame()
    }

    func startGame() {
        let scene = GameScene(size: size)
        scene.scaleMode = .resizeFill
        view?.presentScene(scene, transition: .doorsOpenHorizontal(withDuration: 0.5))
    }
}
