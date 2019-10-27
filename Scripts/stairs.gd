extends Area2D

onready var world = $'..'

func _on_stairs_body_entered(body):
	if body.is_in_group("player"):
		world.ascend()
