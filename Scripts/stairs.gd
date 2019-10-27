extends Area2D

onready var map = $'..'

func _on_stairs_body_entered(body):
	if body.is_in_group("player"):
		map.ascend()
