# SKHexGrid

An example project using [SpriteKit](https://developer.apple.com/spritekit/) and [HexGrid](https://github.com/fananek/hex-grid) to draw hexagonal grids in various configurations.


## How to use this project

1. Download this project
2. Open the project in Xcode
3. Pick a deployment target (any iOS or iPadOS simulator should work)
4. Run the project
5. Use the configuration button (gear icon in upper-right) to switch between different types of grid layout


## History / Release Notes

### v0.3.0

* new grid options for Irregular Hexagons & Parallelograms
* made most colors customizable
* added customization of coordinate label color and font size
* added initial shading options, edges, 2-color edges, rings, and tri-color
* tweaked defaults to not show the secondary overlay grid, picked new colors & shading
* added an option to change the size of (or remove) the border between cells

### v0.2.0

Roughly corresponds to HexGrid version 0.4.10.

* draws coordinates on top of each grid cell (type is based on the configuration)
* fixed iPadOS & macOS targets which were crashing when opening the config menu
* moved from using `isHighlighted` to using a state `Int` instead, with some state colors defined in `Cell+State.swift`
* moved from touch delegate methods to gesture-based input in `HexGridScene`

### v0.1.0

* draws a grid based on a configurable state object, including square, hex, and triangle examples


## Backlog / ideas list

* Make additional things configurable
  - arbitrary coordinates for "custom" generation
  - the frame of the hexagon?
* Add additional "initial shading" options
  - three-color rings
  - 2-color and 3-color border coloring (only on the edges)
* interaction ideas
  - Add a toggle (& settings section) for drag & associated colors
  - Add a second tap state, so you can toggle between three colors empty->tap1->tap2
  - Add an option to add shapes on top of the grid as opposed to fully coloring the tapped cell, maybe with user-configurable hexagon states:
    - options might include: color change, add shape of color (square, circle, triangle?)
    - initially, tap would just toggle through the configured states
    - this would change drag functionality to move state from one coordinate to another
* Remember the background color for each cell so tapping/dragging doesn't mess up the initial colors
* Add more visual effects
  - animate the border of a tapped cell
  - screen shake
  - growing and shrinking of cells
* Add the concept of a "current cell", and buttons to highlight various cells relative to that cell. (The idea here would be to expose more of the HexGrid API in the demo.)
  - neighboring cells
  - diagonally neighboring cells
  - shortest path to some other cell
* Add a navigation to additional "canned" examples
  - An example drawn with `UIKit`
  - An example that does not "fit" to the screen size, and instead is much larger and scrolls off screen in all directions
  - A fully functioning game example? ([Hex](https://en.wikipedia.org/wiki/Hex_(board_game)) maybe?)
  - Could just be lots of different configurations.
* additional coordinate ideas
  - allow shifting of all grid coordinates (this has been started in the shifting-coordinates branch)
    - 1 direction at a time
    - moving offset coordinate 0,0 all the way to an edge of the grid
  - allow drawing coordinates as letters
  - toggle drawing an extra cell in 2 or 3 directions, and only drawing coordinates (for the relevant axis) in that cell
* Put this on testflight
  - add an about screen, with links to github, abstractpuzzle.com, and redblobgames original tutorials
* Allow the user to save their hex grid (possibly including current states)
* Allow the user to export the current grid
  - as single image
  - as PDF, specifying the size of each cell


### Some ideas more suitable for the main hex-grid project

* remove `Cell` `isOpaque` and `isBlocked` properties in favor of attributes with the same names
  - write optional "where" clauses for all the functions that use them instead. (This would allow the API to return all cells neighboring a cell _where_ an attribute is true, or to find a path of cells sharing an attribute, similar.)
