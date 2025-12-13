import HexGrid
import UIKit

extension Cell {

    fileprivate static let kStateAttribute: String = "kStateAttribute-key"

    public enum State: Int, Codable {
        case empty
        case tapped
        case tappedASecondTime
        case touchStarted
        case touchContinued
        case touchEnded
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

struct CellStateConfiguration: Codable {
    let state: Cell.State
    let associatedColor: ColorCodable
}
