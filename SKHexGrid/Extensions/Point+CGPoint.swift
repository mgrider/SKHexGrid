import SwiftUI
import HexGrid

extension Point {
    public var cgPoint : CGPoint {
        return CGPoint(x: x, y: y)
    }

    public func offset(by offsetPoint: Point) -> Point {
        return Point(x: x + offsetPoint.x, y: y + offsetPoint.y)
    }
}

extension CGPoint {
    public var hexPoint : Point {
        return Point(x: x, y: y)
    }
}
