extends KinematicBody2D

var health = 20
var speed = 5

var walkAnim = "Walk"
var attackAnim = "Attack"
var deathAnim = "Death"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Walk")
	pass # Replace with function body.

func _process(delta):
	pass