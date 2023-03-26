import SwiftUI
import HexGrid

class SaveMenuViewData: ObservableObject {

    enum PresetLoadType: String, CaseIterable {
        case simpleExample
        case defaultGray
        case randomColorParallelogram
        case whiteBorderlessEdges
        case blueExtendedTall
        case pinkTriangle
        case goBoardSquare

        func buttonName() -> String {
            switch self {
            case .simpleExample:
                return "Load simple grid example"
            case .defaultGray:
                return "Load default gray grid"
            case .randomColorParallelogram:
                return "Load random color parallelogram"
            case .whiteBorderlessEdges:
                return "Load elegant white grid"
            case .blueExtendedTall:
                return "Load blue extended tall"
            case .pinkTriangle:
                return "Load pink triangle"
            case .goBoardSquare:
                return "Load 13x13 hex Go board"
            }
        }
    }

    struct Preset {
        let name: String
        let presetType: PresetLoadType
    }

    @Published var presets: [Preset] = loadPresets()
    static func loadPresets() -> [Preset] {
        var presets = [Preset]()
        for type in PresetLoadType.allCases {
            presets.append(Preset(name: type.buttonName(), presetType: type))
        }
        return presets
    }

    @Published var wantsSaveAsImage = false
    @Published var wantsPresetLoad: PresetLoadType? = nil

    func config(for type: PresetLoadType) -> ConfigurationData {
        let config = ConfigurationData()
        switch type {
        case .simpleExample:
            // this is not used
            break
        case .defaultGray:
            break
        case .randomColorParallelogram:
            config.gridType = .parallelogram
            config.pointsUp = false
            config.gridSizeX = 15
            config.gridSizeY = 14
            config.initialShading = .random
            config.borderWidth = 3
            config.colorForHexagonBorder = .white
            config.colorForBackground = .gray
            config.showsCoordinates = .none
        case .whiteBorderlessEdges:
            config.gridSizeX = 5
            config.gridSizeY = 5
            config.initialShading = .edgesTwoColor
            config.borderWidth = 5
            config.colorForHexagonBorder = .white
            config.colorForBackground = .white
            config.showsCoordinates = .none
        case .blueExtendedTall:
            config.gridType = .extendedHexagon
            config.gridSizeX = 5
            config.gridSizeY = 12
            config.pointsUp = false
            config.showsCoordinates = .none
            config.borderWidth = 10
            config.colorForHexagonBorder = Color(red: 47/256, green: 108/256, blue: 140/256)
            config.colorForStateEmpty = Color(red: 210/256, green: 239/256, blue: 253/256)
            config.initialShading = .edgesTwoColor
            config.colorForStateEmptySecondary = Color(red: 61/256, green: 138/256, blue: 176/256)
            config.colorForStateEmptyTertiary = Color(red: 90/256, green: 196/256, blue: 247/256)
            config.colorForBackground = Color(red: 214/256, green: 214/256, blue: 214/256)
        case .pinkTriangle:
            config.gridType = .triangle
            config.gridSizeX = 13
            config.colorForBackground = Color(red: 203/256, green: 240/256, blue: 255/256)
            config.initialShading = .rings
            config.colorForStateEmpty = Color(red: 255/256, green: 181/256, blue: 175/256)
            config.colorForStateEmptySecondary = Color(red: 244/256, green: 164/256, blue: 192/256)
            config.colorForStateEmptyTertiary = Color(red: 255/256, green: 140/256, blue: 130/256)
            config.borderWidth = 10
            config.colorForHexagonBorder = Color(red: 249/256, green: 211/256, blue: 224/256)
        case .goBoardSquare:
            config.gridType = .rectangle
            config.gridSizeX = 13
            config.gridSizeY = 13
            config.pointsUp = false
            config.showsCoordinates = .none
            config.borderWidth = 1
            config.colorForHexagonBorder = .black
            config.colorForStateEmpty = Color(red: 251/256, green: 232/256, blue: 108/256)
            config.initialShading = .none
            config.interactionTapType = .shapeAddStone
            config.colorForStateTapped = Color(red: 235/256, green: 235/256, blue: 235/256)
            config.interactionTap2Type = .shapeAddStone
            config.colorForStateTapped2 = Color(red: 51/256, green: 51/256, blue: 51/256)
            config.interactionDragType = .none
            config.colorForBackground = .white
        }
        return config
    }
}
