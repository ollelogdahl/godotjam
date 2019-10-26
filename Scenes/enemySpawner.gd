extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var enemyScene = preload("res://Scenes/enemy.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var enemy = enemyScene.instance()
	enemy.position = position + Vector2(4, 4)
	get_parent().get_parent().get_parent().get_node("enemies").add_child(enemy)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
