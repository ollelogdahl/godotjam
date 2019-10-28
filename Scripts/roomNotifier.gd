extends Area2D

onready var world = $'../../'
var room

signal BEGIN_EVENT(room)

func _on_roomNotifyer_body_entered(body):
	# kolla om det är en spelare som enterat
	if body.is_in_group("player"):
		emit_signal("BEGIN_EVENT", room)
		queue_free()
