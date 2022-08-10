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

    fileprivate var stateInt : Int {
        return self.attributes[Cell.kStateAttribute]?.value as? Int ?? -1
    }

    var state: State {
        return State(rawValue: stateInt) ?? .empty
    }

    func setState(to: State) {
        self.attributes[Cell.kStateAttribute] = .init(to.rawValue)
    }
}
