extends Node

onready var map = $'../..'

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
	
	addStairs(stairRoom)
	addDoor(stairRoomCorridor, 0)

func addStairs(stairRoom):
	# välj en tile i rummet
	var tile = selectTileInRoom(stairRoom)
	tileMap.set_cellv(tile, 2)
	
	var stairs = preload("res://Scenes/stairs.tscn").instance()
	stairs.position = tile * 8 + Vector2(4, 4)
	map.add_child(stairs)
	
func addKey(index, keyId):
	var room = rooms[index]
	var tile = selectTileInRoom(room)
	
	var key = preload("res://Scenes/key.tscn").instance()
	key.id = keyId
	key.tileMap = tileMap
	key.position = tile * 8 + Vector2(4, 4)
	
	map.add_child(key)
	
func addDoor(corridor, id):
	var doorX = corridor.x * 8 + 4
	var doorY = corridor.y * 8 + 4
	
	var door = preload("res://Scenes/door.tscn").instance()
	
	# placerar dörren
	door.position = Vector2(doorX, doorY)
	door.name = "door_" + str(id)
	
	tileMap.add_child(door)

func selectFloorTileInRoom(room):
	var tile
	var valid = false
	while not valid:
		tile = selectTileInRoom(room)
		if tileMap.get_cellv(tile / 8) == 0:
			valid = true
	
	return tile

func selectTileInRoom(room):
	var relX = 1 + rng.randi() % (room.w -2)
	var relY = 1 + rng.randi() % (room.h -2)
	
	var x = relX + room.x
	var y = relY + room.y
	
	return Vector2(x, y)