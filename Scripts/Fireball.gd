extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction

var fireballSpeed = 90
var fireball_damage = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("burn")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (direction * fireballSpeed * delta)
	pass


func _on_Fireball_body_entered(body: PhysicsBody2D):
	if not body:
		queue_free()
		return
		
	if body.is_in_group("enemies"):
		body.takeDamage(fireball_damage, direction, 1)
		queue_free()

func set_direction(dir):
	direction = dir
	
func set_damage(dmg):
	fireball_damage = dmg