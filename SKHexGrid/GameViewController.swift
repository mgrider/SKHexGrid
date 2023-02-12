import HexGrid
import SpriteKit
import SwiftUI
import UIKit

class GameViewController: UIViewController {

    var displayData = ConfigurationData()

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
                    self.hex = self.presentGridShape(viewData: self.displayData)
                    hostingController.dismiss(animated: true)
            })
            let vc = UIHostingController(rootView: view)
            self.hostingController = vc
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }, for: .touchUpInside)
        return button
    }()

    var hex: HexGridScene?

    var hostingController: UIHostingController<ConfigurationSheetView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(configButton)
        configButton.translatesAutoresizingMaskIntoConstraints = false
        configButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        configButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true

        if let view = self.view as! SKView? {
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
        }
    }

    private func presentGridShape(viewData: ConfigurationData) -> HexGridScene? {
        guard let view = self.view as? SKView else { return nil }
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
