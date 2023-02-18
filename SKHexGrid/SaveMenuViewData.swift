import SwiftUI
import HexGrid

class SaveMenuViewData: ObservableObject {

    enum PresetLoadType: String, CaseIterable {
        case simpleExample
        case defaultGray
        case randomColorSquare
        case whiteBorderlessEdges
        case pinkTriangle

        func buttonName() -> String {
            switch self {
            case .simpleExample:
                return "Load simple grid example"
            case .defaultGray:
                return "Load default gray grid"
            case .randomColorSquare:
                return "Load random rectangle grid"
            case .whiteBorderlessEdges:
                return "Load elegant white grid"
            case .pinkTriangle:
                return "Load pink triangle"
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
        case .randomColorSquare:
            config.gridType = .rectangle
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
        }
        return config
    }
}
