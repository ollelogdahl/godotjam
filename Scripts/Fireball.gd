extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var direction

var fireballSpeed = 30
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
		body.take_damage(fireball_damage)
		queue_free()
		
	pass # Replace with function body.

func set_direction(dir):
	direction = dir
	
func set_damage(dmg):
	fireball_damage = dmg