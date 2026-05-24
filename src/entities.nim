import naylib
export naylib

type Item* = object
    kind*: string
    amount*: int32
    perishable*: bool
    weapon*: bool
    # healing*: bool
    healingPoints*: int32
    damage*: int32
    # damage*: Option[int32]
    # healingPoints*: Option[int32]

type Player* = object
    health*: int32
    x*: float32
    y*: float32
    width*: int32
    height*: int32
    xVelocity*: int32
    yVelocity*: int32
    damage*: int32
    alive*: bool
    onGround*: bool
    jumping*: bool
    inventory*: seq[Item]

type Enemy* = object
    species*: string
    health*: int32
    damage*: int32
    x*: float32
    y*: float32
    width*: int32
    height*: int32
    xVelocity*: int32
    yVelocity*: int32
    alive*: bool

type Tile* = object
    kind*: string
    rec*: Rectangle
    collider*: bool


type Room* = object
    items*: seq[Item]
    enemies*: seq[Enemy]
    tiles*: seq[Tile]
    exits*: int32

type Game* = object
    player: var Player
    rooms: array[20, Room]

#TODO create a tilemap type which will be a field in Level
#TODO create a spriteSheet type that will be a field in player and enemy objects
