import std/[random], entities, naylib
export naylib

proc attack*[T: Player|Enemy, U: Player|Enemy](ent1:T, ent2: var U) =
    ent2.health -= rand(int32(1) .. ent1.damage)

proc heal*(p: var Player, i: Item) = 
    if i.healingPoints > 0:
        p.health.inc(i.healingPoints)
    else:
        return

proc pickUpItem*(p: var Player, i: Item) = 
    p.inventory.add(i)

# TODO Swim logic - might need separate swim function to include movement, time limits, damage, and death logic

proc checkVerticalCollisions*(p: var Player, tiles: seq[Tile], screenHeight: int32) =
    if p.y + float32(p.height) >= float32(screenHeight):
        p.onGround = true
    if p.y > float32(screenHeight):
        p.y -= float32(p.height)
    for tile in tiles:
        if checkCollisionRecs(Rectangle(x: p.x, y: p.y, width: float32(p.width), height: float32(p.height)), tile.rec):
            if p.y < tile.rec.y:
                p.onGround = true
            if p.y > tile.rec.y:
                p.onGround = false
                p.jumping = false
    
            
        

proc checkHorizontalCollisions*(p: var Player, tiles: seq[Tile], screenWidth: int32) =
    for tile in tiles:

        if checkCollisionRecs(Rectangle(x: p.x, y: p.y, width: float32(p.width), height: float32(p.height)), tile.rec):
            if p.xVelocity > 0 and p.y  > tile.rec.y :
                p.x -= float32(p.width/2)
            if p.xVelocity > 0 and p.y + float32(p.height) > tile.rec.y + float32(10):
                p.x -= float32(p.width/2)
            
            if p.xVelocity < 0 and p.y > tile.rec.y: 
                p.x += float32(p.width/2)
            if p.xVelocity < 0 and p.y + float32(p.height) > tile.rec.y + float32(10):
                p.x += float32(p.width/2)
            

    if p.x + float32(p.width) >= float32(screenWidth):
        p.x -= float32(p.width/2)
    if p.x  <= float32(0):
        p.x += float32(p.width/2)

proc chase*(e: var Enemy, p: Player) =
    if e.x < p.x:
        e.x += float32(e.xVelocity)
    if e.x > p.x:
        e.x -= float32(e.xVelocity)
    if e.y < p.y:
        e.y += float32(e.yVelocity)
    if e.y > p.y:
        e.y -= float32(e.yVelocity)


#Need to substitute tilemap for the generateed rooms used for testing. 
proc update*(p: var Player, tiles: seq[Tile], screenWidth: int32, screenHeight: int32, jumpTimer: var int32, e: var Enemy) =
    p.yVelocity = 0  #necessary for gravity to work
    var gravity: int32
    #Walk logic
    if isKeyDown(Right) and p.xVelocity < 15 and p.onGround:
        p.xVelocity += 3
    if isKeyDown(Left) and p.xVelocity > -15 and p.onGround:
        p.xVelocity -= 3
    #climb logic
    if isKeyDown(Up):
        p.yVelocity = -2
    # if isKeyDown(Down):
    #     p.yVelocity = 2
    #jump logic
    if isKeyDown(Space) and p.onGround:
        p.onGround = false
        p.jumping = true
    
    #gravity 
    if p.y + p.height.float32 <= screenHeight.float32:
        p.onGround = false
    #intertia
    if p.xVelocity > 0 and not isKeyDown(Right):
        p.xVelocity -= 1
    if p.xVelocity < 0 and not isKeyDown(Left):
        p.xVelocity += 1
    
    
    checkHorizontalCollisions(p, tiles, screenWidth)
    checkVerticalCollisions(p, tiles, screenHeight)


    #checks for conditions: falling, jumping, etc.
    if not p.onGround:
        gravity = 10
    else:
        gravity = 0
    if jumpTimer > 50:
        p.jumping = false
        jumpTimer = 0
    if p.jumping:
        p.yVelocity -= 30
        inc(jumpTimer) 
    
    p.yVelocity += gravity
    
    p.y += float32(p.yVelocity) 
    p.x += float32(p.xVelocity)

    chase(e, p)
    


#[The functions below reed the tilemap array, uses index to determine coordinates of tile and value to determine type of tile: origin, conditions, e.g., collider, etc. The second function iterates of the new tilemap seq and draws it to the screen
TODO refactor readTileMap to read data from tmj - encoding/json library
]#

proc readTileMap*(tilemap: entities.Tilemap): seq[Tile] = 
    var tiles: seq[Tile] = @[]
    var imageX: int32
    var imageY: int32
    for index, val in tilemap.pairs:
        #TODO add additional cases for the other types of tiles
        case val:
            of 1:
                imageX = 0
                imageY = 0
                add(tiles, Tile(rec: Rectangle(x: float32(index mod 40) * 32, y: (float32(index div 40) * 32), width: 32, height: 32), collider: true, imageX: imageX, imageY: imageY))
            else: continue
            # of 5:
            #     imageX = 64
            #     imageY = 0
            #     add(tiles, Tile(rec: Rectangle(x: float32(int32(cIndex) * int32(16)), y: float32(int32(rIndex) * int32(16)), width: 16, height: 16), collider: true, imageX: imageX, imageY: imageY))
    return tiles


#This function draws the map from the tilesheet using drawTextureRec function - need to find naylib equivalent

proc drawMap*(mapTiles: seq[Tile], tileSheet: Texture) =
    for tile in mapTiles:
        var source = Rectangle(x: tile.imageX.float32, y: tile.imageY.float32, width: 32, height: 32)
        var pos = entities.Vector2(x: tile.rec.x, y: tile.rec.y)
        drawTexture(tileSheet, source, pos, White )


    