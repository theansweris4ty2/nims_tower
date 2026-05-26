import std/[random], entities, game_logic, maps

const screenWidth = 1280
const screenHeight = 960

var p = Player(health: 20, x: 100.0, y: 700.0, width: 32, height: 32, xVelocity: 1, yVelocity: 1, damage: 8, alive: true, onGround: true, inventory: newSeqOfCap[Item](10))
var e = Enemy(species: "Orc", health: 20, x: 50.0, y: 700.0, width: 50, height: 50, xVelocity: 2, yVelocity: 2, damage: 8, alive: true)


proc main()= 
  var map = readTileMap(map1)
  var timer: int32
  initWindow(screenWidth, screenHeight, "Nims Tower")
  setTargetFPS(60)
  randomize()

  var mapImage = loadImage("assets/Cave Tiles/Cave Tiles2.png")
  var backgroundImage = loadImage("assets/Cave Tiles/cave background.png")
  var tileset = loadTextureFromImage(mapImage)
  var caveBackground = loadTextureFromImage(backgroundImage)
  while not windowShouldClose():
    timer.inc
    update(p, map, screenWidth, screenHeight, timer, e)
    beginDrawing()
    clearBackground(Black)
    let playerRectangle = Rectangle(x: p.x, y: p.y, width: float32(p.width), height: float32(p.height))
    let enemyRectangle = Rectangle(x: e.x, y: e.y, width: float32(e.width), height: float32(e.height))
    drawTexture(caveBackground, 0, 300, White)
    drawMap(map, tileset)
    drawRectangle(playerRectangle, Red)
    drawRectangle(enemyRectangle, Green)
    
    endDrawing()
    # unloadTexture(tileSet)
  closeWindow()





main()

