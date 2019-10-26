extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var dungeonTilesetRes = preload("res://ResourceObjects/dungeonTileset.tres")
onready var enemySpawner = preload("res://Scenes/enemySpawner.tscn")
var dungeonRoom = preload("res://Scripts/dungeonRoomClass.gd")
onready var parent = get_parent()

onready var navigation2D = $'/root/Node/world/Navigation2D'

var roomCount = 44
var iterations = 300
var roomMean = 11
var roomStdev = 2.5
var initialSize = 10
var spreadFactor = 0.1

var rng = RandomNumberGenerator.new()
var path = AStar.new()

var player_spawn = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_player_spawn():
	return player_spawn


# Genererar tilemapen
func generate():
	# generera seed
	rng.randomize()
	var mapSeed = rng.randi()
	rng.seed = mapSeed
	
	# Skapa en ny node TileMap för denna dungeon
	var tileMap = TileMap.new()
	tileMap.name = "floor_%X" % mapSeed
	
	#parent.call_deferred("add_child", tileMap) # temporär
	navigation2D.add_child(tileMap)
	
	# sätter värden på tileMap
	tileMap.cell_size = Vector2(8, 8)
	tileMap.tile_set = dungeonTilesetRes
	
	print("Dungeon " + tileMap.name + " init..")

	# börja generera dungeon
	
	# exempel
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
	
	createMonsters(tileMap)
	createPlayerSpawns(16, 16, tileMap)
	
	

#	var rooms = generateRoomSizes() # genererar tight packade rum
#	roomSeparation(rooms) # sprider ut rummen
#
#	for r in rooms:
#		createRoom(r.x, r.y, r.w, r.h, tileMap)
#
#	# skapar spännande träd
#	var graph = createMST(rooms)
#
#	# bygger korridorer som kopplar samman rummen enligt trädet
#	generateCorridors(graph)

	print("Dungeon " + tileMap.name + " created!")
	
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
func createMonsters(trg):
	for cell in trg.get_used_cells():
		if trg.get_cellv(cell) == 0 and rng.randf() > 0.95:
			var spawner = enemySpawner.instance()
			spawner.name = "enemySpawner %s" % cell
			spawner.position = cell * 8
			trg.add_child(spawner)
func createPlayerSpawns(x1, y1, trg):
	var spawn1 = Node2D.new()
	
	spawn1.add_to_group("spawners")
	
	spawn1.name = "playerSpawn"
	spawn1.position = Vector2(x1, y1)
	player_spawn = Vector2(x1, y1)
	trg.add_child(spawn1)
	
func createMST(rooms):
	# ta reda på minimala spännande träd 
	# Prims Algorithm
	#var path = AStar.new()
	var idFirst = path.get_available_point_id()
	path.add_point(idFirst, Vector3(rooms[0].x, rooms[0].y, 0))
	rooms[0].point = idFirst
	
	for r in range(1, len(rooms)):
		var minDist = INF
		var minPosition
		var position
		
		for p1 in path.get_points():
			var p1Position = path.get_point_position(p1)
			
			for i in range(r, len(rooms)):
				var p2 = rooms[i]
				
				if p1Position.distance_to(p2.vec3()) <= minDist:
					minDist = p1Position.distance_to(p2.vec3())
					minPosition = p2
					position = p1Position
		
		var n = path.get_available_point_id()
		path.add_point(n, minPosition.vec3())
		path.connect_points(path.get_closest_point(position), n)
		rooms[r].point = n
	return path
func roomSeparation(rooms):
	# förflyttar rum utåt tills inga längre kolliderar
	for i in range(roomCount):
		for e in range(iterations):
			for j in range(roomCount):
				if i == j:
					break
			
				if rooms[i].collidesWith(rooms[j]):
					# beräkna vektorn som pekar på j från i
					var a = rooms[i]
					var b = rooms[j]
					var dx = (b.x + b.w/2) - (a.x + a.w/2)
					var dy = (b.y + b.h/2) - (a.y + a.h/2)
				
					# flytta rummet i motsatt riktning
					rooms[i].x -= dx * spreadFactor
					rooms[i].y -= dy * spreadFactor
	var centerX = 0
	var centerY = 0
	for i in range(roomCount):
		centerX += rooms[i].x
		centerY += rooms[i].y
	centerX /= roomCount
	centerY /= roomCount


	# gravitation wooow
	gravity(rooms)
	for i in rooms:	
		for j in rooms:
			if i == j:
				continue
			# or i.vec3().distance_to(Vector3(centerX,centerY,0)) > 80
			if i.collidesWith(j):
				rooms.erase(j)
				
	for r in rooms:
		#clampa värdena till ints igen
		r.x = int(r.x) 
		r.y = int(r.y) 
		r.w = int(r.w) 
		r.h = int(r.h)
	return rooms
func gravity(rooms):
	var centerX = 0
	var centerY = 0
	for i in range(roomCount):
		centerX += rooms[i].x
		centerY += rooms[i].y
	centerX /= roomCount
	centerY /= roomCount
	
	
	for i in range(roomCount):
		var collided = false
		
		for e in range(iterations):
			var x_diff = rooms[i].x - centerX
			var y_diff = rooms[i].y - centerX
			#rooms[i].x -= (x_diff)  * 0.1
			for j in range(roomCount):
				if i == j:
					continue
					
				if rooms[i].collidesWith(rooms[j]):
					collided = true
					break
			if not collided:
				rooms[i].x -= (x_diff)  * 0.1
				rooms[i].y -= (y_diff)  * 0.1 

func generateRoomSizes():
	var rooms = []
	for i in range(roomCount):
		var x = rng.randi() % initialSize
		var y = rng.randi() % initialSize
		
		var w = rng.randfn(roomMean, roomStdev)
		var h = rng.randfn(roomMean, roomStdev)
		
		rooms.append( dungeonRoom.new(x, y, w, h) )
	
	return rooms
func generateCorridors(graph):
	for p in graph.get_points():
		for c in graph.get_point_connections(p):
			
			pass

func _process(delta):
    update()
func _draw():
    if path:
        for p in path.get_points():
            for c in path.get_point_connections(p):
                var pp = path.get_point_position(p)
                var cp = path.get_point_position(c)
                draw_line(Vector2(pp.x, pp.y)*8, Vector2(cp.x, cp.y)*8, Color(1, 0, 0, 1), 2, true)