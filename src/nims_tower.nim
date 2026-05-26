import std/[random], entities, game_logic, maps

const screenWidth = 1280
const screenHeight = 960

var p = Player(health: 20, x: 100.0, y: 700.0, width: 32, height: 32, xVelocity: 1, yVelocity: 1, damage: 8, alive: true, onGround: true, inventory: newSeqOfCap[Item](10))
var e = Enemy(species: "Orc", health: 20, x: 50.0, y: 700.0, width: 50, height: 50, xVelocity: 2, yVelocity: 2, damage: 8, alive: true)
let potion = Item(kind: "healing potion", amount: 1, perishable: true, weapon: false, damage: 0, healingPoints: 3)
let potion2 = Item(kind: "healing potion", amount: 1, perishable: true, weapon: false, damage: 0, healingPoints: 5)

proc main()= 
  var map = readTileMap(map1)
  var timer: int32
  initWindow(screenWidth, screenHeight, "Nims Tower")
  setTargetFPS(60)
  randomize()

  var mapImage = loadImage("assets/Cave Tiles/Cave Tiles2.png")
  var tileset = loadTextureFromImage(mapImage)
  while not windowShouldClose():
    timer.inc
    update(p, map, screenWidth, screenHeight, timer, e)
    beginDrawing()
    clearBackground(RayWhite)
    let playerRectangle = Rectangle(x: p.x, y: p.y, width: float32(p.width), height: float32(p.height))
    let enemyRectangle = Rectangle(x: e.x, y: e.y, width: float32(e.width), height: float32(e.height))
    # for tile in room.tiles:
    #   drawRectangle(tile.rec, Blue)
    drawRectangle(playerRectangle, Red)
    drawRectangle(enemyRectangle, Green)
    # drawTexture(tileSet, 0, 0, White)
    drawMap(map, tileset)
    endDrawing()
    # unloadTexture(tileSet)
  closeWindow()





main()

