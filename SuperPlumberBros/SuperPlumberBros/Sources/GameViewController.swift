import SpriteKit
import UIKit

final class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let view = SKView(frame: UIScreen.main.bounds)
        view.ignoresSiblingOrder = true
        view.showsFPS = false
        view.showsNodeCount = false
        self.view = view

        let scene = TitleScene(size: view.bounds.size)
        scene.scaleMode = .resizeFill
        view.presentScene(scene)
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        .landscape
    }

    override var prefersStatusBarHidden: Bool { true }
    override var prefersHomeIndicatorAutoHidden: Bool { true }

    // MARK: - Hardware keyboard (arrows + Z/Space = jump, X = run)

    override func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if !handlePresses(presses, down: true) { super.pressesBegan(presses, with: event) }
    }

    override func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if !handlePresses(presses, down: false) { super.pressesEnded(presses, with: event) }
    }

    override func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        if !handlePresses(presses, down: false) { super.pressesCancelled(presses, with: event) }
    }

    @discardableResult
    private func handlePresses(_ presses: Set<UIPress>, down: Bool) -> Bool {
        var handled = false
        for p in presses {
            guard let key = p.key else { continue }
            let name: String?
            switch key.keyCode {
            case .keyboardLeftArrow: name = "left"
            case .keyboardRightArrow: name = "right"
            case .keyboardUpArrow, .keyboardSpacebar, .keyboardZ: name = "jump"
            case .keyboardX, .keyboardLeftShift, .keyboardRightShift: name = "run"
            case .keyboardReturnOrEnter:
                if down {
                    if let t = (view as? SKView)?.scene as? TitleScene { t.startGame() }
                    else if let g = (view as? SKView)?.scene as? GameScene { g.requestReset() }
                }
                name = nil
            default: name = nil
            }
            if let name {
                ((view as? SKView)?.scene as? GameScene)?.keyChanged(name, down: down)
                handled = true
            }
        }
        return handled
    }
}
