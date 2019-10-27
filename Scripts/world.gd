extends Navigation2D



var players = []
var player_1
var player_2
var mapGenerator

var currentTileMap = null
var rememberedFloorSeeds = []
var currentFloor = 0

var spawn = Vector2(40,40)

func _ready():
	player_1 = $Player1
	player_2 = $Player2
	mapGenerator = $dungeonGenerator
	
	players.append(player_1)
	players.append(player_2)
	
	initFloor()

func initFloor():
	currentTileMap = mapGenerator.generateDungeon()
	spawn_players(mapGenerator.get_player_spawn())
	get_node("/root/Node").dungeon_is_created()

func spawn_players(spawn):
	player_1.position = spawn + Vector2(4, 4)
	player_2.position = Vector2(spawn.x + 12, spawn.y + 4)
	player_1.player_controller_id = 0
	player_2.player_controller_id = 1

func ascend():
	print("players ascending...")
	
	# spara senaste våningen
	rememberedFloorSeeds.append(mapGenerator.mapSeed)
	currentFloor += 1
	
	cleanWorld()
	initFloor()

func cleanWorld():
	currentTileMap.free() # radera tilemap
	for node in $enemies.get_children():
		node.queue_free()

func getPlayer1():
	return player_1
func getPlayer2():
	return player_2
