extends KinematicBody2D

var health = 20
var speed = 5

var walkAnim = "Walk"
var attackAnim = "Attack"
var deathAnim = "Death"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Walk")
	$Sprite.scale= Vector2(1,1)
	pass # Replace with function body.

func _process(delta):
	pass


func take_damage(damage):
	print("hit")
	health -= damage
	
	if health <= 0:
		$AnimationPlayer.play("Death")

func death():
	queue_free()