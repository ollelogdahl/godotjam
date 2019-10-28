extends Node

onready var world = $'../..'
onready var root_Node = $"/root/Node"

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
func createCrystalRoom(index):
	var room = rooms[index]
	
	var tile = selectCenterTileInRoom(room)
	addFloorFeature(tile.x-2, tile.y-2, 4, 4, 4)
	addCrystal(tile)
	
	# skapa roomNotifyer och bind signal till world.event()
	addNotifier(room, 'BEGIN_EVENT', 'event')

func addStairs(tile):
	# välj en tile i rummet
	tileMap.set_cellv(tile, 5)
	
	var stairs = preload("res://Scenes/stairs.tscn").instance()
	stairs.position = tile * 8 + Vector2(4, 4)
	root_Node.stair_pos = stairs.position
	world.add_child(stairs)
func addKey(index, keyId):
	var room = rooms[index]
	var tile = selectTileInRoom(room)
	
	var key = preload("res://Scenes/key.tscn").instance()
	key.id = keyId
	key.tileMap = tileMap
	key.position = tile * 8 + Vector2(4, 4)
	root_Node.key_pos = key.position
	world.add_child(key)
func addShrine(roomIndex):
	
	var shrine = preload("res://Scenes/shrine.tscn").instance()
	
	var room = rooms[roomIndex]
	var tile = selectTileInRoom(room, 1)
	
	shrine.position = tile * 8
	root_Node.shrine_pos = shrine.position
	world.add_child(shrine)
func addDoor(corridor, id):
	var doorX = corridor.x * 8 + 4
	var doorY = corridor.y * 8 + 4
	
	var door = preload("res://Scenes/door.tscn").instance()
	
	# placerar dörren
	door.position = Vector2(doorX, doorY)
	door.name = "door_" + str(id)
	
	tileMap.add_child(door)
func addCrystal(tile):
	var crystal = preload("res://Scenes/crystal.tscn").instance()
	crystal.position = tile * 8
	root_Node.crystal_pos = crystal.position
	world.add_child(crystal)

func addFloorFeature(x,y, w,h, id): 
	if w > 1 and h > 1:
		for j in range(h):
			for i in range(w):
				if tileMap.get_cell(x+i, y+j) == 0:
					tileMap.set_cell(x+i, y+j, id)

func addNotifier(room, sig, callback):
	var notifier = preload('res://Scenes/roomNotifier.tscn').instance()
	notifier.position = Vector2(room.x + float(room.w/2), room.y + float(room.h/2)) * 8 + Vector2(4, 4)
	
	var shape = RectangleShape2D.new()
	shape.extents = Vector2(room.w/2, room.h/2) * 8
	notifier.get_node('CollisionShape2D').shape = shape
	notifier.room = room
	notifier.connect(sig, world, callback)
	tileMap.add_child(notifier)

func selectCenterTileInRoom(room):
	var x : int = room.x + (room.w/2) + 1
	var y : int = room.y + (room.h/2) + 1
	
	return Vector2(x, y)
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