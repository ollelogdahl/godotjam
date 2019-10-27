extends Area2D


var id
var tileMap

func _on_key_body_entered(body):
	if body.is_in_group("player"):
		# ta bort dörr med id
		var door = tileMap.get_node("door_" + str(id))
		door.queue_free()
		queue_free()
