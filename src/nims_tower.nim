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
  var camera = Camera2D(offset: Vector2(x: float32(screenWidth/2), y: float32(screenHeight/2)),target: Vector2(x: 100,y: 100),  rotation: float32(0.0), zoom: float32(3.0))

  

  var mapImage = loadImage("assets/16x16roguelike.png")
  
  var tileset = loadTextureFromImage(mapImage)

  while not windowShouldClose():
    timer.inc
    update(p, map, screenWidth, screenHeight, timer, e, camera)
    beginDrawing()
    beginMode2D(camera)
    clearBackground(Black)
    let playerRectangle = Rectangle(x: p.x, y: p.y, width: float32(p.width), height: float32(p.height))
    let enemyRectangle = Rectangle(x: e.x, y: e.y, width: float32(e.width), height: float32(e.height))
    drawMap(map, tileset)
    # drawRectangle(playerRectangle, Red)
    # drawRectangle(enemyRectangle, Green)
    endMode2D()
    endDrawing()
    # unloadTexture(tileSet)
  closeWindow()





main()

