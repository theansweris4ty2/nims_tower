import std/[random], entities, game_logic

const screenWidth = 1000
const screenHeight = 750

var p = Player(health: 20, x: 30.0, y: 30.0, width: 50, height: 50, xVelocity: 1, yVelocity: 1, damage: 8, alive: true, onGround: true, inventory: newSeqOfCap[Item](10))
var e = Enemy(species: "Orc", health: 20, x: 50.0, y: 700.0, width: 50, height: 50, xVelocity: 2, yVelocity: 2, damage: 8, alive: true)
let potion = Item(kind: "healing potion", amount: 1, perishable: true, weapon: false, damage: 0, healingPoints: 3)
let potion2 = Item(kind: "healing potion", amount: 1, perishable: true, weapon: false, damage: 0, healingPoints: 5)

proc main()= 
  var timer: int32
  initWindow(screenWidth, screenHeight, "Nims Tower")
  setTargetFPS(60)
  randomize()
  let room = generateRooms()
  while not windowShouldClose():
    timer += 1
    update(p, room.tiles, screenWidth, screenHeight, timer, e)
    beginDrawing()
    clearBackground(RayWhite)
    let playerRectangle = Rectangle(x: p.x, y: p.y, width: float32(p.width), height: float32(p.height))
    let enemyRectangle = Rectangle(x: e.x, y: e.y, width: float32(e.width), height: float32(e.height))
    for tile in room.tiles:
      drawRectangle(tile.rec, Blue)
    drawRectangle(playerRectangle, Red)
    drawRectangle(enemyRectangle, Green)
    endDrawing()
  closeWindow()





main()

