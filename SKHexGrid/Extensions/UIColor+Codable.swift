import UIKit
import SwiftUI

extension UIColor {
    static func random() -> UIColor {
        // decent bright colors
        return UIColor(hue: .random(in: 0.0..<1.0), saturation: 0.7, brightness: 0.9, alpha: 1.0)
        // light
//        return UIColor(hue: .random(in: 0.0..<1.0), saturation: 0.4, brightness: 1.0, alpha: 1.0)
        // dark
//        return UIColor(hue: .random(in: 0.0..<1.0), saturation: 0.6, brightness: 0.6, alpha: 1.0)

    }

    static func trulyRandom() -> UIColor {
        return UIColor(
            red: CGFloat(arc4random()) / CGFloat(UInt32.max),
            green: CGFloat(arc4random()) / CGFloat(UInt32.max),
            blue: CGFloat(arc4random()) / CGFloat(UInt32.max),
            alpha: 1.0
        )
    }
}

struct ColorCodable: Codable, Equatable {
    let hue, saturation, brightness, alpha: CGFloat

    init(_ swiftUIColor: Color) {
        self.init(uiColor: UIColor(swiftUIColor))
    }

    init(swiftUIColor: Color) {
        self.init(uiColor: UIColor(swiftUIColor))
    }

    init(uiColor: UIColor) {
//        var r, g, b, a: CGFloat
//        (r, g, b, a) = (0, 0, 0, 0)
//        uiColor.getRed(&r, green: &g, blue: &b, alpha: &a)

        var h, s, b, a: CGFloat
        (h, s, b, a) = (0, 0, 0, 0)
        uiColor.getHue(&h, saturation: &s, brightness: &b, alpha: &a)

        self.hue = h
        self.saturation = s
        self.brightness = b
        self.alpha = a
    }

    func uIColor() -> UIColor {
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
    }

    func swiftUIcolor() -> Color {
        return Color(uIColor())
    }
}
