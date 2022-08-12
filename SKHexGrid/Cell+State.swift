import HexGrid
import UIKit

extension Cell {

    fileprivate static let kStateAttribute: String = "kStateAttribute-key"

    public enum State: Int {
        case empty
        case tapped
        case touchStarted
        case touchContinued
        case touchEnded

        public var color: UIColor {
            switch self {
            case .empty:
                return UIColor.lightGray
            case .tapped:
                return .systemOrange
            case .touchStarted:
                return UIColor(red: 59/256, green: 172/256, blue: 182/256, alpha: 1.0)
            case .touchContinued:
                return UIColor(red: 130/256, green: 219/256, blue: 216/256, alpha: 1.0)
            case .touchEnded:
                return UIColor(red: 179/256, green: 232/256, blue: 229/256, alpha: 1.0)
            }
        }
    }

    var state: State {
        get {
            guard let stateInt = self.attributes[Cell.kStateAttribute]?.value as? Int else {
                return .empty
            }
            return State(rawValue: stateInt) ?? .empty
        }
        set (newValue) {
            self.attributes[Cell.kStateAttribute] = .init(newValue.rawValue)
        }
    }

}
