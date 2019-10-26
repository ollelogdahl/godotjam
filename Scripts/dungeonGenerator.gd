extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dungeonTilesetRes = preload("res://ResourceObjects/dungeonTileset.tres")
onready var parent = get_parent()

var dungeonRoom = preload("res://Scripts/dungeonRoomClass.gd")

var dungeonSize = 100
var roomCount = 12

var initialSize = 40
var roomMean = 8
var roomStdev = 4

var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	generate()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

# Genererar tilemapen
func generate():
	# generera seed
	rng.randomize()
	var mapSeed = rng.randi()
	rng.seed = mapSeed
	
	# Skapa en ny node TileMap för denna dungeon
	var tileMap = TileMap.new()
	tileMap.name = "floor_%X" % mapSeed
	
	parent.call_deferred("add_child", tileMap) # temporär
	
	# sätter värden på tileMap
	tileMap.cell_size = Vector2(8, 8)
	tileMap.tile_set = dungeonTilesetRes
	
	print("Dungeon " + tileMap.name + " init..")

	# börja generera dungeon
	
	# exempel
	createRoom(0, 0, 10, 10, tileMap)
	createRoom(12, 4, 7, 11, tileMap)
	createRoom(13, -4, 9, 5, tileMap)
	createCorridor(10, 8, 0, 3, tileMap)
	createCorridor(15, 4, 1, 4, tileMap)
	
	# generera rum
	var rooms = []
	#for i in range(roomCount):
	#	var x = rng.randi() % dungeonSize
	#	var y = rng.randi() % dungeonSize
	#	
	#	var w = rng.randi_range(minRoomInitial, maxRoomInitial)
	#	var h = rng.randi_range(minRoomInitial, maxRoomInitial)
	#	
	#	createRoom(x, y, w, h, tileMap)
	
	# skapar rum
	for i in range(roomCount):
		var x = rng.randi() % initialSize
		var y = rng.randi() % initialSize
		
		var w = rng.randfn(roomMean, roomStdev)
		var h = rng.randfn(roomMean, roomStdev)
		
		rooms.append( dungeonRoom.new(x, y, w, h) )
		
	# förflyttar rum utåt tills inga längre kolliderar
	for r in range(roomCount):
		
		pass
	
func createRoom(x, y, w, h, trg):
	# skapa väggar
	for i in range(w):
		trg.set_cell(x + i, y, 1)
		trg.set_cell(x + i, y + h, 1)
	for i in range(h):
		trg.set_cell(x, y + i, 1)
		trg.set_cell(x + w, y + i, 1)
	trg.set_cell(x+w, y+h, 1)
	
	# fyll golv
	for i in range(w-1):
		for j in range(h-1):
			trg.set_cell(x + i + 1, y + j + 1, 0)
func createCorridor(x, y, d, l, trg):
	if d == 0:   # H
		for i in range(l):
			trg.set_cell(x+i, y-1, 1) # övre vägg
			trg.set_cell(x+i, y+1, 1) # nedre vägg
			trg.set_cell(x+i, y,   0) # golv
		pass
	elif d == 1: # U
		for i in range(l):
			trg.set_cell(x-1, y-i, 1) # vänster vägg
			trg.set_cell(x+1, y-i, 1) # höger vägg
			trg.set_cell(x  , y-i, 0) # golv
	elif d == 2: # V
		for i in range(l):
			trg.set_cell(x+i, y-1, 1) # övre vägg
			trg.set_cell(x+i, y+1, 1) # nedre vägg
			trg.set_cell(x+i, y,   0) # golv
	elif d == 3: # N
		for i in range(l):
			trg.set_cell(x+i, y-1, 1) # övre vägg
			trg.set_cell(x+i, y+1, 1) # nedre vägg
			trg.set_cell(x+i, y,   0) # golv