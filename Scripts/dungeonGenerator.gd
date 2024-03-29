extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var root_node = $"/root/Node"

onready var world = $'../'

onready var dungeonRoom = preload("res://Scripts/Classes/dungeonRoomClass.gd")
onready var dungeonCorridor = preload("res://Scripts/Classes/dungeonCorridorClass.gd")

var steps := 12
var roomMean := 14
var roomStdev := 2.8

var mapSeed := -1

var rng = RandomNumberGenerator.new()

var player_spawn = Vector2()
func get_player_spawn():
	return player_spawn

# generate() wrapper
func generateDungeon():
	print("Generating dungeon:")
	root_node.reset_elements()
	var tileMap = generate()
	print("Dungeon done.")
	return tileMap
	
# 3412135123
#3230097303 <- lagging AI
#863820525 <- fungerar bättre med AI
# Genererar hela dungeonen
func generate(s = -1):
	
	# generera seed
	if s != -1:
		rng.seed = s
		mapSeed = s
	else:
		rng.randomize()
		mapSeed = rng.randi()
		rng.seed = mapSeed
	
	# Skapa en ny node(TileMap) för denna dungeon
	var tileMap = TileMap.new()
	tileMap.name = "floor_%X" % mapSeed
	
	# konfigurerar tileMap
	tileMap.cell_size = Vector2(8, 8)
	tileMap.tile_set = preload("res://ResourceObjects/dungeonTileset.tres")
	
	# lägger till den som node under navigation2D
	#    detta krävs för pathfindingen
	world.add_child(tileMap)
	
	print(tileMap.name + " > init..")


	# Generera dungeon layout
	$dungeonLayout.buildDungeon(steps, roomMean, roomStdev, mapSeed)
	
	

	
	print(tileMap.name + " > layout generated.")
	
	# fyller tilemapen med layoutens rum och korridorer
	for room in $dungeonLayout.rooms:
		createRoom(room.x, room.y, room.w, room.h, tileMap)
	for c in $dungeonLayout.corridors:
		createCorridor(c.x, c.y, c.dir, c.length, tileMap)
	
	print(tileMap.name + " > tilemap finalized.")
	
	createMonsters(tileMap)
	createPlayerSpawns(16, 16, tileMap)
	
	print(tileMap.name + " > spawns added.")
	
	$roomPopulator.init($dungeonLayout.rooms, $dungeonLayout.corridors, tileMap)
	
	# lägg till trappa upp
	var roomStairIndex = len($dungeonLayout.rooms) -1
	$roomPopulator.createStairRoom(roomStairIndex)
	
	# lägg till event rum
	var eventRoomIndex := 1
	for r in range(len($dungeonLayout.rooms)-2):
		if r == len($dungeonLayout.rooms)-2:
			break # detta är stairRoom
		if $dungeonLayout.rooms[r+1].size() > $dungeonLayout.rooms[eventRoomIndex].size():
			eventRoomIndex = r+1
	#if(rng.randf() > 0.5):
	$roomPopulator.createCrystalRoom(eventRoomIndex)
	
	# välj vilket rum nyckeln ska finnas i
	var keyRoomIndex = 2 + rng.randi() % (len($dungeonLayout.rooms) - 4)
	$roomPopulator.addKey(keyRoomIndex, 0)
	
	# slumpar om en shrine ska finnas
	if(rng.randf() > 0.7):
		var valid = false
		var shrineRoomIndex = 0
		while not valid:
			shrineRoomIndex = 2 + rng.randi() % (len($dungeonLayout.rooms) - 4)
			if not shrineRoomIndex == keyRoomIndex:
				valid = true
		$roomPopulator.addShrine(shrineRoomIndex)
	
	print(tileMap.name + " > elements added.")
	get_node("/root/Node").add_elements_to_minimap()
	
	return tileMap

func buildDebugDungeon(tileMap):
	createRoom(0, 0, 10, 10, tileMap)
	createRoom(12, 4, 7, 11, tileMap)
	createRoom(13, -4, 9, 5, tileMap)
	createRoom(20, 8, 12, 12, tileMap)
	createRoom(1, 16, 14, 10, tileMap)
	createCorridor(10, 8, 0, 3, tileMap)
	createCorridor(15, 4, 1, 4, tileMap)
	createCorridor(19, 12, 0, 2, tileMap)
	createCorridor(4, 16, 1, 7, tileMap)
	createCorridor(15, 18, 0, 6, tileMap)
	
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
	match d:
		0: # H
			for i in range(l):
				trg.set_cell(x+i, y-1, 1) # övre vägg
				trg.set_cell(x+i, y+1, 1) # nedre vägg
				trg.set_cell(x+i, y,   0) # golv
		1: # U
			for i in range(l):
				trg.set_cell(x-1, y-i, 1) # vänster vägg
				trg.set_cell(x+1, y-i, 1) # höger vägg
				trg.set_cell(x  , y-i, 0) # golv
		2: # V
			for i in range(l):
				trg.set_cell(x-i, y-1, 1) # övre vägg
				trg.set_cell(x-i, y+1, 1) # nedre vägg
				trg.set_cell(x-i, y,   0) # golv
		3: # N
			for i in range(l):
				trg.set_cell(x-1, y+i, 1) # vänster vägg
				trg.set_cell(x+1, y+i, 1) # höger vägg
				trg.set_cell(x  , y+i, 0) # golv

func createMonsters(trg):
	for cell in trg.get_used_cells():
		if trg.get_cellv(cell) == 0 and rng.randf() > 0.99:
			world.spawnEnemy(cell * 8)
func createPlayerSpawns(x1, y1, trg):
	var spawn1 = Node2D.new()
	
	spawn1.add_to_group("spawners")
	
	spawn1.name = "playerSpawn"
	spawn1.position = Vector2(x1, y1)
	player_spawn = Vector2(x1, y1)
	trg.add_child(spawn1)