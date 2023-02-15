import SwiftUI
import HexGrid

class SaveData: ObservableObject {

    enum PresetLoadType: String, CaseIterable {
        case defaultGray
    }

    @Published var wantsSaveAsImage = false
    @Published var wantsPresetLoad: PresetLoadType? = nil

}

struct SaveMenuView: View {

    @StateObject public var gameData = SaveData()

    var doneButtonCallback: ((SaveData) -> Void)?

    var body: some View {

        NavigationView {

            List {

                Section("Save to Photo Library") {

                    VStack {
                        Text("These options will save the image to your photo library.").font(.caption)
                        Button("Save grid at current screen size") {
                            gameData.wantsSaveAsImage = true
                            doneButtonCallback?(gameData)
                        }.buttonStyle(.bordered)
                    }

                }

                Section("Load Preset Grid") {

                    VStack {
                        Button("Load default grid") {
                            gameData.wantsPresetLoad = .defaultGray
                            doneButtonCallback?(gameData)
                        }.buttonStyle(.bordered)
                        Text("WARNING: This will reset all configuration options.").font(.caption)
                    }

                }

            }.padding()
                .navigationBarTitle(Text("Save Menu"), displayMode: .inline)
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

//struct ExampleConfigurationSheetView_Previews: PreviewProvider {
//    static var previews: some View {
//        Group {
//            ConfigurationSheetView()
//        }
//    }
//}

