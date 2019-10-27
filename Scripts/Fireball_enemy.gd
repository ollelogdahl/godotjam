extends Area2D

var direction

var fireballSpeed = 30
var fireball_damage = 10

func _ready():
	$AnimationPlayer.play("burn")

func _process(delta):
	position += (direction * fireballSpeed * delta)
	pass


func _on_Fireball_body_entered(body: PhysicsBody2D):
	if not body:
		queue_free()
		return
		
	if body.is_in_group("players"):
		body.take_damage(fireball_damage)
		queue_free()

func set_direction(dir):
	direction = dir
	
func set_damage(dmg):
	fireball_damage = dmg