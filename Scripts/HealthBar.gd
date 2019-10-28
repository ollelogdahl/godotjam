extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maxHealth = 20
onready var health_bar = $TextureProgress

var p1_health = preload("res://Resources/UI/p1Healthbar.png")
var p2_health = preload("res://Resources/UI/p2Healthbar.png")
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass # Replace with function body.

func set_to_player_1():
	health_bar.texture_progress = p1_health
func set_to_player_2():
	health_bar.texture_progress = p2_health
	

func set_max_health(value):
	maxHealth = value

	
func update_health(health):

	health_bar.value = health
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
