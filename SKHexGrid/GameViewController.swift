import HexGrid
import SpriteKit
import SwiftUI
import UIKit

class GameBackgroundScene: SKScene {
    override init(size: CGSize) {
        super.init(size: size)
        self.scaleMode = .fill
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class GameViewController: UIViewController {

    lazy var aboutButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = 8
        background.backgroundColor = .white.withAlphaComponent(0.75)
        config.background = background
        config.image = UIImage(systemName: "questionmark.circle")
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            // open config
            let view = AboutView(
                doneButtonCallback: { [weak self] in
                    guard let self = self else { return }
                    guard let hostingController = self.aboutHostingController else { return }
                    hostingController.dismiss(animated: true)
                })
            let vc = UIHostingController(rootView: view)
            self.aboutHostingController = vc
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }, for: .touchUpInside)
        return button
    }()

    var aboutHostingController: UIHostingController<AboutView>?

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
                gameData: ConfigurationViewData.from(config: Self.hexConfig),
                doneButtonCallback: { [weak self] model in
                    guard let self else { return }
                    guard let hostingController = self.configHostingController else { return }
                    self.gameView?.transform = .identity
                    model.update(hexGridConfiguration: &Self.hexConfig)
                    self.updateGridFromModel(model: Self.hexConfig)
                    hostingController.dismiss(animated: true)
            })
            let vc = UIHostingController(rootView: view)
            self.configHostingController = vc
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }, for: .touchUpInside)
        return button
    }()

    var configHostingController: UIHostingController<ConfigurationSheetView>?

    /// just a tiny bit of a singleton here...
    static var hexConfig: HexGridConfig = HexGridConfig()

    var gameView: SKView?

    var hex: HexGridScene?

    var hexSecondaryView: SKView?

    lazy var resetTransformButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = 8
        background.backgroundColor = .white.withAlphaComponent(0.75)
        config.background = background
        config.image = UIImage(systemName: "arrowshape.turn.up.backward")
        button.configuration = config
        button.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            guard let gameView = self.gameView else { return }
            gameView.transform = .identity
            self.resetTransformButton.isHidden = true
        }, for: .touchUpInside)
        return button
    }()

    lazy var saveMenuButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.plain()
        var background = UIBackgroundConfiguration.clear()
        background.cornerRadius = 8
        background.backgroundColor = .white.withAlphaComponent(0.75)
        config.background = background
        config.image = UIImage(systemName: "square.and.arrow.down")
        button.configuration = config
        let action: UIAction = UIAction { [weak self] _ in
            guard let self else { return }
            // open save menu
            let view = SaveMenuView(doneButtonCallback: { saveData in
                guard let hostingController = self.saveMenuHostingController else { return }
                if saveData.wantsSaveAsImage, let size = saveData.wantsSaveSize {
                    self.saveImage(withSize: size)
                }
                if saveData.wantsSaveAsShare, let size = saveData.wantsSaveSize {
                    self.shareImage(withSize: size)
                }
                if saveData.wantsLoadSimpleGridExample {
                    self.presentSimpleGridExample()
                    self.gameView?.transform = .identity
                } else {
                    if let wantsConfig = saveData.wantsPresetLoad {
                        self.updateGridFromModel(model: saveData.config(for: wantsConfig))
                    } else {
                        self.updateGridFromModel(model: Self.hexConfig)
                    }
                    self.gameView?.transform = .identity
                }
                hostingController.dismiss(animated: true)
            })
            let vc = UIHostingController(rootView: view)
            self.saveMenuHostingController = vc
            vc.modalPresentationStyle = .formSheet
            self.present(vc, animated: true)
        }
        button.addAction(action, for: .touchUpInside)
        return button
    }()

    var saveMenuHostingController: UIHostingController<SaveMenuView>?

    override func viewDidLoad() {
        super.viewDidLoad()

        if let data = UserDefaults.standard.currentHexGridConfig {
            Self.hexConfig = data
        }

        if let view = self.view as! SKView? {

            let bgView = SKView(frame: .init(origin: .zero, size: view.frame.size))
            let bgScene = GameBackgroundScene(size: view.frame.size)
            bgScene.backgroundColor = Self.hexConfig.colorForBackground.uIColor()
            bgView.presentScene(bgScene)
            view.addSubview(bgView)
            bgView.translatesAutoresizingMaskIntoConstraints = false
            bgView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            bgView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            bgView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            bgView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            self.background = bgScene

            let side = min(view.frame.size.height, view.frame.size.width)
            let gameView = SKView(frame: .init(
                x: 0,
                y: (view.frame.size.height - side)/2.0,
                width: side,
                height: side))
            view.addSubview(gameView)
            setupConstraints(forGameView: gameView, relativeTo: view)
            self.gameView = gameView

            hex = presentGridShape(viewData: Self.hexConfig)
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true

            // This really has no purpose other than to show that you can have
            // an arbitrary number of grids shown on the screen at once.
            let hex2 = SKView(frame: CGRect(x: 10, y: 70, width: 150, height: 150))
            let hexScene = HexGridScene(
                config: Self.hexConfig,
                size: CGSize(width: 150, height: 150)
            )
            hexScene.scaleMode = .aspectFit
            hexScene.backgroundColor = .yellow
            hex2.presentScene(hexScene)
            view.addSubview(hex2)
            hexSecondaryView = hex2
            hexSecondaryView?.isHidden = !Self.hexConfig.showYellowSecondaryGrid

            view.addSubview(configButton)
            configButton.translatesAutoresizingMaskIntoConstraints = false
            configButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            configButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20).isActive = true

            view.addSubview(saveMenuButton)
            saveMenuButton.translatesAutoresizingMaskIntoConstraints = false
            saveMenuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            saveMenuButton.rightAnchor.constraint(equalTo: configButton.leftAnchor, constant: -20).isActive = true

            view.addSubview(aboutButton)
            aboutButton.translatesAutoresizingMaskIntoConstraints = false
            aboutButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            aboutButton.rightAnchor.constraint(equalTo: saveMenuButton.leftAnchor, constant: -20).isActive = true

            view.addSubview(resetTransformButton)
            resetTransformButton.translatesAutoresizingMaskIntoConstraints = false
            resetTransformButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
            resetTransformButton.rightAnchor.constraint(equalTo: aboutButton.leftAnchor, constant: -20).isActive = true
            resetTransformButton.isHidden = true

            let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinchGesture))
            view.addGestureRecognizer(pinch)

            let drag = UIPanGestureRecognizer(target: self, action: #selector(didReceivePanGesture(sender:)))
            drag.minimumNumberOfTouches = 2
            drag.maximumNumberOfTouches = 2
            drag.delegate = self
            view.addGestureRecognizer(drag)
        }

    }

    private func setupConstraints(forGameView gameView: UIView, relativeTo view: UIView) {
//            gameView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        gameView.translatesAutoresizingMaskIntoConstraints = false
        var gameViewConstraints: [NSLayoutConstraint] = []
        gameViewConstraints.append(gameView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor))
        gameViewConstraints.append(gameView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor))
        gameViewConstraints.append(gameView.leftAnchor.constraint(greaterThanOrEqualTo: view.leftAnchor))
        gameViewConstraints.append(gameView.rightAnchor.constraint(lessThanOrEqualTo: view.rightAnchor))
        let sidesEqual = gameView.widthAnchor.constraint(equalTo: gameView.heightAnchor, multiplier: 1)
        sidesEqual.priority = .defaultHigh
        gameViewConstraints.append(gameView.centerXAnchor.constraint(equalTo: view.centerXAnchor))
        gameViewConstraints.append(gameView.centerYAnchor.constraint(equalTo: view.centerYAnchor))
        gameViewConstraints.append(sidesEqual)
        NSLayoutConstraint.activate(gameViewConstraints)
    }

    private func presentGridShape(viewData: HexGridConfig) -> HexGridScene? {
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

    private func presentSimpleGridExample() {
        guard let view = self.gameView else { return }
        // default background color and hidden state of secondary grid
        self.background?.backgroundColor = .black
        hexSecondaryView?.isHidden = true
        // make sure our hex scene is square
        let side = min(view.frame.size.height, view.frame.size.width)
        let size = CGSize(width: side, height: side)
        let hexScene = SimpleHexGridScene(
            size: size
        )
        hexScene.scaleMode = .aspectFit
        view.presentScene(hexScene)
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

    // MARK: pinch/zoom

    @objc func didReceivePinchGesture(sender: UIPinchGestureRecognizer) {
        guard Self.hexConfig.isInteractionPinchZoomAllowed else { return }
        guard let gameView = self.gameView else { return }
        gameView.transform = gameView.transform.scaledBy(x: sender.scale, y: sender.scale)
        sender.scale = 1
        resetTransformButton.isHidden = false
    }

    @objc func didReceivePanGesture(sender: UIPanGestureRecognizer) {
        guard Self.hexConfig.isInteractionTwoFingerDragGridAllowed else { return }
        guard let gameView = self.gameView else { return }
        guard sender.numberOfTouches == 2 else { return }
        let translation = sender.translation(in: view)
        sender.setTranslation(.zero, in: view)
        gameView.transform = gameView.transform.translatedBy(x: translation.x, y: translation.y)
        resetTransformButton.isHidden = false
    }

    // MARK: updating the current grid

    func updateGridFromModel(model: HexGridConfig) {
        Self.hexConfig = model
        self.view.backgroundColor = model.colorForBackground.uIColor()
        background?.backgroundColor = model.colorForBackground.uIColor()
        hex = presentGridShape(viewData: model)
        hexSecondaryView?.isHidden = !model.showYellowSecondaryGrid
    }

    // MARK: saving to photo library

    func saveImage(withSize size: CGSize) {
        guard let view = self.gameView else { return }
        let selector = #selector(self.onImageSaved(_:error:contextInfo:))
        view.snapshotImage(withSize: size)?.saveToPhotoLibrary(self, selector)
    }

    @objc private func onImageSaved(_ image: UIImage, error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "The current grid has been saved to your photo library.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }

    // MARK: sharing the image with the system prompt

    func shareImage(withSize size: CGSize) {
        if let saveMenuHostingController {
            saveMenuHostingController.dismiss(animated: false)
        }
        guard let view = self.gameView,
              let image = view.snapshotImage(withSize: size)
        else {
            let ac = UIAlertController(title: "Image share error", message: "There was an error saving your image. Please try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        let imagesArray = [image]
        let activityViewController = UIActivityViewController(activityItems: imagesArray, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.excludedActivityTypes = []
        present(activityViewController, animated: true)
    }
}

extension GameViewController: UIGestureRecognizerDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool {
        return true
    }
}
