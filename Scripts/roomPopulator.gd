extends Node

onready var world = $'../..'

var rooms
var corridors
var tileMap
var rng = RandomNumberGenerator.new()

func init(r, c, tm):
	rooms = r
	corridors = c
	tileMap = tm

func createStairRoom(index):
	var stairRoom = rooms[index]
	var stairRoomCorridor = corridors[index-1]
	
	var tile = selectTileInRoom(stairRoom)
	addStairs(tile)
	addDoor(stairRoomCorridor, 0)
	addFloorFeature(tile.x-1, tile.y-1, 3, 3, 3)

func addStairs(tile):
	# välj en tile i rummet
	tileMap.set_cellv(tile, 5)
	
	var stairs = preload("res://Scenes/stairs.tscn").instance()
	stairs.position = tile * 8 + Vector2(4, 4)
	world.add_child(stairs)
func addKey(index, keyId):
	var room = rooms[index]
	var tile = selectTileInRoom(room)
	
	var key = preload("res://Scenes/key.tscn").instance()
	key.id = keyId
	key.tileMap = tileMap
	key.position = tile * 8 + Vector2(4, 4)
	
	world.add_child(key)
func addShrine(roomIndex):
	
	var shrine = preload("res://Scenes/shrine.tscn").instance()
	
	var room = rooms[roomIndex]
	var tile = selectTileInRoom(room, 1)
	
	shrine.position = tile * 8
	
	world.add_child(shrine)
func addDoor(corridor, id):
	var doorX = corridor.x * 8 + 4
	var doorY = corridor.y * 8 + 4
	
	var door = preload("res://Scenes/door.tscn").instance()
	
	# placerar dörren
	door.position = Vector2(doorX, doorY)
	door.name = "door_" + str(id)
	
	tileMap.add_child(door)

func addFloorFeature(x,y, w,h, id): 
	if w > 1 and h > 1:
		for j in range(h):
			for i in range(w):
				if tileMap.get_cell(x+i, y+j) == 0:
					tileMap.set_cell(x+i, y+j, id)

func selectFloorTileInRoom(room, offset=0):
	var tile
	var valid = false
	while not valid:
		tile = selectTileInRoom(room, offset)
		if tileMap.get_cellv(tile / 8) == 0:
			valid = true
	
	return tile
func selectTileInRoom(room, offset=0):
	var relX = 1 + offset + rng.randi() % (room.w -2 -offset)
	var relY = 1 + offset + rng.randi() % (room.h -2 -offset)
	
	var x = relX + room.x
	var y = relY + room.y
	
	return Vector2(x, y)