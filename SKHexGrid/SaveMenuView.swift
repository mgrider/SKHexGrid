import SwiftUI

struct SaveMenuView: View {

    @State public var gameData = SaveMenuViewData()

    @State private var isPresentingSaveDialog = false
    @State private var saveName = Date().description(with: nil)
    @State private var saveNamesArray = UserDefaults.standard.saveHexGridDataNamesArray

    var doneButtonCallback: ((SaveMenuViewData) -> Void)?

    let imageSizes: [CGFloat] = [600, 1024, 1080, 2048, 3840]

    var body: some View {

        NavigationView {

            List {

                Section("Load grid configuration") {

                    HStack {
                        Menu("From a preset") {
                            ForEach(gameData.presets, id: \.presetType) { preset in
                                Button(preset.name.capitalized) {
                                    gameData.wantsPresetLoad = preset.presetType
                                    doneButtonCallback?(gameData)
                                }
                            }
                        }
                        Spacer()
                    }

                    if !saveNamesArray.isEmpty {
                        HStack {
                            Menu("From a save") {
                                ForEach(saveNamesArray, id: \.self) { name in
                                    Button(name) {
                                        guard let config = UserDefaults.standard.savedHexGridConfig(named: name) else {
                                            return
                                        }
                                        GameViewController.hexConfig = config
                                        gameData.wantsLoadFromConfig = true
                                        doneButtonCallback?(gameData)
                                    }
                                }
                            }
                            Spacer()
                        }
                    }

                    HStack {
                        Button("Configure a random grid") {
                            gameData.wantsPresetLoad = .completelyRandomConfiguration
                            doneButtonCallback?(gameData)
                        }.buttonStyle(.borderless)
                        Spacer()
                    }

                    VStack {
                        HStack {
                            Button("Load the simple grid example") {
                                gameData.wantsLoadSimpleGridExample = true
                                doneButtonCallback?(gameData)
                            }.buttonStyle(.borderless)
                            Spacer()
                        }
                        HStack {
                            Text("This example is not configurable.").font(.caption)
                            Spacer()
                        }
                    }

                    Text("WARNING: These options will reset the currently configured grid.").font(.caption)

                }

                Section("Save grid configuration") {

                    HStack {
                        Button("Save grid configuration") {
                            isPresentingSaveDialog = true
                        }
                        .buttonStyle(.borderless)
                        .alert("Save as...", isPresented: $isPresentingSaveDialog) {
                            TextField("Save name", text: $saveName)
                            Button("OK") {
                                UserDefaults.standard.saveHexGridConfig(
                                    GameViewController.hexConfig,
                                    withName: saveName
                                )
                                saveNamesArray = UserDefaults.standard.saveHexGridDataNamesArray
                            }
                            Button("Cancel", role: .cancel) { }
                        } message: {
                            Text("You can give it a name.")
                        }
                        Spacer()
                    }

                }

                Section("Save or share a photo") {

                    HStack {
                        Menu("Save image to photo library...") {
                            ForEach(0..<imageSizes.count, id: \.self) { value in
                                Button("\(Int(imageSizes[value])) x \(Int(imageSizes[value]))") {
                                    gameData.wantsSaveAsImage = true
                                    gameData.wantsSaveSize = .init(width: imageSizes[value], height: imageSizes[value])
                                    doneButtonCallback?(gameData)
                                }
                            }
                        }
                        Spacer()
                    }

                    HStack {
                        Menu("Share an image...") {
                            ForEach(0..<imageSizes.count, id: \.self) { value in
                                Button("\(Int(imageSizes[value])) x \(Int(imageSizes[value]))") {
                                    gameData.wantsSaveAsShare = true
                                    gameData.wantsSaveSize = .init(width: imageSizes[value], height: imageSizes[value])
                                    doneButtonCallback?(gameData)
                                }
                            }
                        }
                        Spacer()
                    }
                    Text("""
This will create an image of the currently configured grid to save to your photo library or share with the system share sheet.
""").font(.caption)

                }

            }
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

