# SKHexGrid

An example project using [SpriteKit](https://developer.apple.com/spritekit/) and [HexGrid](https://github.com/fananek/hex-grid) to draw hexagonal grids in various configurations. 

## TODO list

* draw coordinates on top of each grid cell (based on the config boolean)
* flush out drawing states that don't work yet:
  * `.rectangle -> .pointyOnTop`
  * `.triangle -> .flatOnTop`
* make sure all dimensions are centered
* support a uniform margin (inset) around the grid
* move from using isHighlighted to using a state int instead and looping through some state colors 
