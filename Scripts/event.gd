extends Node

onready var world = $'../'

var enemiesKilled := 0
var room = null

var corners = []

func _ready():
	# event startat
	corners.append(Vector2(room.x + 1,          room.y + 1))
	corners.append(Vector2(room.x + room.w - 1, room.y + 1))
	corners.append(Vector2(room.x + 1,          room.y + room.h - 1))
	corners.append(Vector2(room.x + room.w - 1, room.y + room.h - 1))
	pass

func _process(delta):
	pass



func _on_Timer_timeout():
	# spawna ny fiende
	var c = randi() % 4
	
	var spawner = preload('res://Scenes/enemySpawner.tscn').instance()
	spawner.position = corners[c] * 8
	world.add_child(spawner)