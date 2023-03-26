import SpriteKit

extension SKShapeNode {

    /// This is a crude approximation of a go-stone-like "piece".
    public static func stoneNode(
        withRadius r: Double
    ) -> SKShapeNode {
        let stoneNode = SKShapeNode(circleOfRadius: r)
        stoneNode.lineWidth = 1
        stoneNode.strokeColor = .lightGray
        stoneNode.zPosition = 2
        if let stoneShadow = stoneNode.copy() as? SKShapeNode {
            stoneShadow.lineWidth = 0
            stoneShadow.fillColor = .black.withAlphaComponent(0.25)
            stoneShadow.position = .init(x: r/8, y: -r/8)
            stoneShadow.zPosition = 1
            stoneNode.addChild(stoneShadow)
        }
        return stoneNode
    }

}
