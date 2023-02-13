import HexGrid
import SpriteKit
import SwiftUI
import UIKit

class GameBackgroundScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameViewController: UIViewController {

    var background: GameBackgroundScene?

    lazy var configButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = 8
        background.backgroundColor = .white.withAlphaComponent(0.75)
        config.background = background
        config.image = UIImage(systemName: "gear")
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            // open config
            let view = ConfigurationSheetView(
                gameData: self.displayData,
                doneButtonCallback: { [weak self] model in
                    guard let self = self else { return }
                    guard let hostingController = self.hostingController else { return }
                    self.background?.backgroundColor = UIColor(model.colorForBackground)
                    self.hex = self.presentGridShape(viewData: self.displayData)
                    self.hexSecondaryView?.isHidden = !model.showYellowSecondaryGrid
                    hostingController.dismiss(animated: true)
            })
            let vc = UIHostingController(rootView: view)
            self.hostingController = vc
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }, for: .touchUpInside)
        return button
    }()

    var displayData = ConfigurationData()

    var gameView: SKView?

    var hex: HexGridScene?

    var hexSecondaryView: SKView?

    var hostingController: UIHostingController<ConfigurationSheetView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let view = self.view as! SKView? {

            let bgView = SKView(frame: .init(origin: .zero, size: view.frame.size))
            let bgScene = GameBackgroundScene(size: view.frame.size)
            bgScene.backgroundColor = UIColor(displayData.colorForBackground)
            bgView.presentScene(bgScene)
            view.addSubview(bgView)
            self.background = bgScene

            let side = min(view.frame.size.height, view.frame.size.width)
            let gameView = SKView(frame: .init(
                x: 0,
                y: (view.frame.size.height - side)/2.0,
                width: side,
                height: side))
            view.addSubview(gameView)
            self.gameView = gameView

            hex = presentGridShape(viewData: self.displayData)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true

            let hex2 = SKView(frame: CGRect(x: 10, y: 70, width: 150, height: 150))
            let hexScene = HexGridScene(
                config: ConfigurationData(
                    number: 2,
                    gridType: .hexagon
                ),
                size: CGSize(width: 150, height: 150)
            )
            hexScene.scaleMode = .aspectFit
            hexScene.backgroundColor = .yellow
            hex2.presentScene(hexScene)
            view.addSubview(hex2)
            hexSecondaryView = hex2
            hexSecondaryView?.isHidden = !displayData.showYellowSecondaryGrid

            view.addSubview(configButton)
            configButton.translatesAutoresizingMaskIntoConstraints = false
            configButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
            configButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        }
    }

    private func presentGridShape(viewData: ConfigurationData) -> HexGridScene? {
        guard let view = self.gameView else { return nil }
        // make sure our hex scene is square
        let side = min(view.frame.size.height, view.frame.size.width)
        let size = CGSize(width: side, height: side)
        let hexScene = HexGridScene(
            config: viewData,
            size: size
        )
        hexScene.scaleMode = .aspectFit
        view.presentScene(hexScene)
        return hexScene
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
