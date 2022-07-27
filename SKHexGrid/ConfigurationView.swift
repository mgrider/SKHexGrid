import SwiftUI
import HexGrid

class ConfigurationData: ObservableObject {

    enum GridType: Hashable {
        case rectangle
        case hexagon
        case triangle
    }
    @Published var associatedNumber: Double = 3
    @Published var gridType: GridType = .hexagon
    @Published var pointsUp = true
    @Published var showsCoordinates = true
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
                        Text("Square").tag(ConfigurationData.GridType.rectangle)
                        Text("Hex").tag(ConfigurationData.GridType.hexagon)
                        Text("Triangle").tag(ConfigurationData.GridType.triangle)
                    }).pickerStyle(SegmentedPickerStyle())
                }
                HStack {
                    Text("Size: \(gameData.associatedNumber, specifier: "%.0f")")
                    Slider(value: $gameData.associatedNumber, in: 1...20) {
                        Text("Size: \(gameData.associatedNumber, specifier: "%.0f")")
                    }
                }

                Toggle(isOn: $gameData.showsCoordinates, label: {
                    Text("Show hexagon coordinates")
                })

                Toggle(isOn: $gameData.pointsUp, label: {
                    Text("Hexagon points face up")
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
