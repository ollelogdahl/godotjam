extends Node2D



# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var players = []
var player_1
var player_2

var spawn = Vector2(40,40)
# Called when the node enters the scene tree for the first time.
func _ready():
	player_1 = $Player1
	player_2 = $Player2
	players.append(player_1)
	players.append(player_2)
	spawn_players()
	pass # Replace with function body.

func spawn_players():

	player_1.position = spawn
	player_2.position = Vector2(spawn.x + 5, spawn.y +5)
	player_1.player_controller_id = 0
	player_2.player_controller_id = 1

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
