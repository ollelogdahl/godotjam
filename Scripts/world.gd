extends Navigation2D


onready var minimap_node = get_node("/root/Node/minimap/Viewport")

var players = []
var player_1
var player_2
var mapGenerator
var crystal_event_activated = false

var currentTileMap = null
var rememberedFloorSeeds = []
var currentFloor = 0

var score := 0
var scoreFloorMultiplier := 1.5
var crystal_event_multiplier = 3

var spawn = Vector2(40,40)

var diedPlayers = 0

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

func spawnEnemy(pos):
	add_to_group("spawners")
	var enemy
	var rand = randf()
	if rand > 0.7:
		enemy = preload("res://Scenes/enemy_two.tscn").instance()
	else:
		enemy = preload("res://Scenes/enemy_pig.tscn").instance()
	enemy.position = pos + Vector2(4, 4)
	enemy.add_to_group("enemies")
	$enemies.add_child(enemy)

func playerDied(s):
	diedPlayers += 1
	
	if diedPlayers == 2:
		# spelet över!!
		endGame()

func ascend():
	print("players ascending...")
	
	# spara senaste våningen
	rememberedFloorSeeds.append(mapGenerator.mapSeed)
	currentFloor += 1
	
	cleanWorld()
	initFloor()

func addEnemyDeathScore(amount):
	var floorMult = max(scoreFloorMultiplier * currentFloor, 1)
	if crystal_event_activated:
		floorMult *= crystal_event_multiplier
	addScore(amount * floorMult)

func addScore(amount):
	score += amount
	var scoreLabel = $'/root/Node/UI/Score'
	scoreLabel.update_score(score)

# triggra event när spelaren går in i eventRummet
func event(r):
	# påbörja event!!
	print("Event initiated...")
	
	# skapa en ny node som tar hand om eventet
	var e = preload("res://Scenes/event.tscn").instance()
	e.room = r
	add_child(e)

func cleanWorld():
	currentTileMap.free() # radera tilemap
	for node in $enemies.get_children():
		node.queue_free()
	
	# ta bort shrine och kristal
	var children = get_children()
	for c in children:
		if c.name == "shrine":
			c.queue_free()
		if c.name == "stairs":
			c.queue_free()
		if c.name == "crystal":
			c.queue_free()

func getPlayer1():
	if player_1:
		return player_1
	else:
		return player_2
func getPlayer2():
	if player_2:
		return player_2
	else:
		return player_1


func endGame():
	pass