import HexGrid
import SpriteKit
import SwiftUI
import UIKit

class GameViewController: UIViewController {

    var configurationSheetView: ConfigurationSheetView?
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
                    guard let configView = self.configurationSheetView else { return }
                    self.presentGridShape()
                    hostingController.dismiss(animated: true)
            })
            self.configurationSheetView = view
            let vc = UIHostingController(rootView: view)
            vc.modalPresentationStyle = .popover
            self.present(vc, animated: true)
            self.hostingController = vc
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
            presentGridShape()
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    private func presentGridShape() {
        guard let view = self.view as? SKView else { return }
        // make sure our hex scene is square
        let side = min(view.frame.size.height, view.frame.size.width)
        let size = CGSize(width: side, height: side)
        hex = HexGridScene(
            config: displayData,
            size: size
        )
        hex?.scaleMode = .aspectFit
        view.presentScene(hex)
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
