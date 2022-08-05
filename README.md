# SKHexGrid

An example project using [SpriteKit](https://developer.apple.com/spritekit/) and [HexGrid](https://github.com/fananek/hex-grid) to draw hexagonal grids in various configurations.

> Please note that main is currently being used for development. For the most stable experience, you may want to download a release, or `git checkout` a release tag.

## How to use this project

1. Download this project
2. Open the project in Xcode
3. Pick a deployment target (an iOS simulator works nicely)
4. Run the project
5. To see different types of grid, you can change the configuration (by pressing the gear button)

## TODO list

* fix (or remove) iPadOS & macOS targets which break when opening the config menu
* move from using `isHighlighted` to using a state `Int` instead and looping through some (configurable?) state colors

## History / Release Notes

### pre-v0.2.0

* draws coordinates on top of each grid cell (type is based on the configuration)

### v0.1.0

* draws a grid based on a configurable state object, including square, hex, and triangle examples
