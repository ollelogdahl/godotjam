extends Area2D

var direction

var fireballSpeed = 30
var fireball_damage = 2

func _ready():
	$AnimationPlayer.play("burn")

func _process(delta):
	position += (direction * fireballSpeed * delta)


func _on_Fireball_body_entered(body):
	if not body:
		queue_free()
	if body.is_in_group("player"):
		body.takeDamage(fireball_damage, direction, 0.4)
		queue_free()

func set_direction(dir):
	direction = dir
	
func set_damage(dmg):
	fireball_damage = dmg