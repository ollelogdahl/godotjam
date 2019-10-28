extends Area2D

var direction

var speed = 180
var damage = 4

var vel

func _ready():
	vel = direction * speed
	look_at(position + direction)
	$Sprite.rotation_degrees += 90

func _process(delta):
	position += vel * delta
	
	vel *= 0.7
	pass
	
func destroy():
	queue_free()

func _on_shockWave_enemy_body_entered(body):
	if body.is_in_group("player"):
		body.takeDamage(damage, direction, 1.5)
		# stäng av kollider och dö senare
		$CollisionShape2D.disabled = true
