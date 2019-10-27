extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var root_node = get_node("/root/Node") 

# Called when the node enters the scene tree for the first time.
func _ready():
	#$dungeonGenerator.generate()
	pass # Replace with function body.

func _process(delta):
	#if Input.is_action_just_pressed("ui_accept"):
	#	$dungeonGenerator.generate()
	pass

func generateDungeon():
	$dungeonGenerator.generate()
	root_node.dungeon_is_created()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
