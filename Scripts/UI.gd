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

func update_healthbar(health, max_health, player_name):
	#print("healt")
	if player_name == "Player1":
		healthbar_p1.set_max_health(max_health)
		healthbar_p1.update_health(health)
	elif player_name == "Player2":
		healthbar_p2.set_max_health(max_health)
		healthbar_p2.update_health(health)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
