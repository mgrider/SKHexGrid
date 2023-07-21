import SwiftUI

struct SaveMenuView: View {

    @StateObject public var gameData = SaveMenuViewData()

    var doneButtonCallback: ((SaveMenuViewData) -> Void)?

    var body: some View {

        NavigationView {

            List {

                Section("Load grid configuration") {

                    HStack {
                        Menu("Pick a preset") {
                            ForEach(gameData.presets, id: \.presetType) { preset in
                                Button(preset.name) {
                                    gameData.wantsPresetLoad = preset.presetType
                                    doneButtonCallback?(gameData)
                                }
                            }
                        }
                        Spacer()
                    }

                    HStack {
                        Button("Configure a random grid") {
                            gameData.wantsPresetLoad = .completelyRandomConfiguration
                            doneButtonCallback?(gameData)
                        }.buttonStyle(.borderless)
                        Spacer()
                    }

                    Text("WARNING: This will reset the currently configured grid options.").font(.caption)

                }

                Section("Load simple grid example") {

                    HStack {
                        Button("Load simple grid example") {
                            gameData.wantsPresetLoad = .simpleExample
                            doneButtonCallback?(gameData)
                        }.buttonStyle(.borderless)
                        Spacer()
                    }

                    Text("This example is not configurable.").font(.caption)

                }

                Section("Save to photo library") {

                    HStack {
                        Button("Save grid at current screen size") {
                            gameData.wantsSaveAsImage = true
                            doneButtonCallback?(gameData)
                        }.buttonStyle(.borderless)
                        Spacer()
                    }
                    Text("""
This will save an image of the currently configured grid to your photo library.

Note that, for now, the size of the image will be a square in the size of the smaller dimension (width or height) of your screen.
""").font(.caption)

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

