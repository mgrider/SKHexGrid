import SwiftUI

struct AboutView: View {

    var doneButtonCallback: (() -> Void)?

    var body: some View {

        NavigationView {

            ScrollView {

                Text("What is SKHexGrid?").font(.title)

                Text("""

SKHexGrid is an [open source](https://github.com/mgrider/skhexgrid) project, showing how to use Apple's SpriteKit and another open source library called [HexGrid](https://github.com/fananek/hex-grid) to draw hexagonal grids in various configurations.


""")

                Text("What can I do with it?").font(.title)

                Text("""

There are a couple of primary uses imagined for this application (outside of its use as an open-source "example project"):

1. You can **configure** and then **Save** images of hexagonal grids for use elsewhere. (For example, you might configure a grid for a [board game played on a hexagonal grid](https://boardgamegeek.com/boardgamemechanic/2026/hexagon-grid), save it, then find it in your photos library and print it from there.)

2. You could also use a grid to play some basic games pass-and-play right here inside the app. There are many games on Board Game Geek playable on a hex grid without much necessary equipment. Here are links to a couple of lists:

    • [games played on a hexagonal grid (of any size), with single color markers/pieces/tokens](https://boardgamegeek.com/geeklist/228019/single-color-hexagons)
    • [hexagonal territorial games with placement/capture but no movement](https://boardgamegeek.com/boardgamemechanic/2026/hexagon-grid)

""")

                Text("Who made this?").font(.title)

                Text("""

`SKHexGrid` was made by Martin Grider. You can find more apps and games by Martin at his website, [http://abstractpuzzle.com](http://abstractpuzzle.com).

The `HexGrid` project was originally created by [František Mikš](https://github.com/fananek) and [Paul McKeown](https://github.com/pmckeown).

HexGrid was heavily influenced by (and in many cases based on) the work of Amit Patel, whose [tutorial on hexagonal grids](https://www.redblobgames.com/grids/hexagons/) has inspired and helped countless game developers for many years.

""")

            }.padding()
                .navigationBarTitle(Text("About this app"), displayMode: .inline)
                .navigationBarItems(
                    trailing: Button(
                        action: {
                            doneButtonCallback?()
                        }) {
                            Text("Done").bold()
                        }
                )

        } // NavigationView

    }
}

struct ExampleAboutView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AboutView()
        }
    }
}
