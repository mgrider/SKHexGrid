import SwiftUI

struct SaveMenuView: View {

    @StateObject public var gameData = SaveMenuViewData()

    var doneButtonCallback: ((SaveMenuViewData) -> Void)?

    var body: some View {

        NavigationView {

            List {

                Section("Load Preset Grid") {

                    VStack {
                        ForEach(gameData.presets, id: \.presetType) { preset in
                            Button(preset.name) {
                                gameData.wantsPresetLoad = preset.presetType
                                doneButtonCallback?(gameData)
                            }.buttonStyle(.bordered)
                        }
                        Text("WARNING: This will reset all configuration options.").font(.caption)
                    }

                }

                Section("Save to Photo Library") {

                    VStack {
                        Text("These options will save the image to your photo library.").font(.caption)
                        Button("Save grid at current screen size") {
                            gameData.wantsSaveAsImage = true
                            doneButtonCallback?(gameData)
                        }.buttonStyle(.bordered)
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

