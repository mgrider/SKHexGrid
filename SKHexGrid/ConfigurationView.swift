import SwiftUI
import HexGrid

class ConfigurationData: ObservableObject {

    enum GridCoordinateType: Hashable {
        case none
        case cube
        case offset
        case axial
    }
    enum GridType: Hashable {
        case custom
        case rectangle
        case hexagon
        case triangle
    }
    @Published var associatedNumber: Double = 3
    @Published var gridType: GridType = .hexagon
    @Published var pointsUp = true
    @Published var offsetEven = true
    @Published var showsCoordinates: GridCoordinateType = .cube

    init(
        number: Double = 3,
        gridType: GridType = .hexagon
    ) {
        self.associatedNumber = number
        self.gridType = gridType
    }
}

struct ConfigurationSheetView: View {

    @StateObject public var gameData = ConfigurationData()

    var doneButtonCallback: ((ConfigurationData) -> Void)?

    var body: some View {

        NavigationView {

            VStack {
                HStack {
                    Text("Grid")
                    Picker("View Type", selection: $gameData.gridType, content: {
                        Text("Custom").tag(ConfigurationData.GridType.custom)
                        Text("Square").tag(ConfigurationData.GridType.rectangle)
                        Text("Hex").tag(ConfigurationData.GridType.hexagon)
                        Text("Triangle").tag(ConfigurationData.GridType.triangle)
                    }).pickerStyle(SegmentedPickerStyle())
                }
                HStack {
                    Text("Size: \(gameData.associatedNumber, specifier: "%.0f")")
                    Slider(value: $gameData.associatedNumber, in: 1...20) {
                        Text("Size: \(gameData.associatedNumber.rounded(), specifier: "%.0f")")
                    }
                }
                HStack {
                    Text("Coordinates")
                    Picker("Coordinate Type", selection: $gameData.showsCoordinates, content: {
                        Text("None").tag(ConfigurationData.GridCoordinateType.none)
                        Text("Cube").tag(ConfigurationData.GridCoordinateType.cube)
                        Text("Axial").tag(ConfigurationData.GridCoordinateType.axial)
                        Text("Offset").tag(ConfigurationData.GridCoordinateType.offset)
                    }).pickerStyle(SegmentedPickerStyle())
                }

                Toggle(isOn: $gameData.pointsUp, label: {
                    Text("Hexagon points face up")
                })

                Toggle(isOn: $gameData.offsetEven, label: {
                    let str: String = gameData.offsetEven ? "Offset is Even" : "Offset is Odd"
                    Text(str)
                })

                Spacer()

            }.padding()
                .navigationBarTitle(Text("Configuration"), displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            doneButtonCallback?(gameData)
                        }) {
                            Text("Done").bold()
                        }
                )

        } // NavigationView

    }
}

struct ExampleConfigurationSheetView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ConfigurationSheetView()
        }
    }
}
