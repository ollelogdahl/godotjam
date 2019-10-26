extends Node2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var players = []
var player_1
var player_2
var map_node

var spawn = Vector2(40,40)
# Called when the node enters the scene tree for the first time.
func _ready():
	player_1 = $Player1
	player_2 = $Player2
	players.append(player_1)
	players.append(player_2)
	map_node = $map
	map_node.generateDungeon()
	var generator_node = map_node.get_node("./dungeonGenerator")
	spawn_players(generator_node.get_player_spawn())
	pass # Replace with function body.

func spawn_players(spawn):
	player_1.position = spawn + Vector2(4, 4)
	player_2.position = Vector2(spawn.x + 12, spawn.y + 4)
	player_1.player_controller_id = 0
	player_2.player_controller_id = 1

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
