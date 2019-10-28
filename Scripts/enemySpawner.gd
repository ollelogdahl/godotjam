extends Node2D

onready var world = $'/root/Node/WorldViewport/Viewport/world/'

onready var enemyScene = preload("res://Scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("spawners")
	var enemy = enemyScene.instance()
	enemy.position = position + Vector2(4, 4)
	enemy.add_to_group("enemies")
	world.get_node("enemies").add_child(enemy)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
