extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var healthbar_p1 = $HealthBar_p1
onready var healthbar_p2 = $HealthBar_p2

# Called when the node enters the scene tree for the first time.
func _ready():
	healthbar_p1.set_to_player_1()
	healthbar_p2.set_to_player_2()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
