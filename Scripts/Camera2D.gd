extends Camera2D


onready var player1 = $"../world/Player1"
onready var player2 = $"../world/Player2"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var c = (player1.position + player2.position) / 2
	position = c
	pass
