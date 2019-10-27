extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("STAIRS_UP", self, "_on_ascend")
	#$dungeonGenerator.generate()
	pass # Replace with function body.

func _process(delta):
	#if Input.is_action_just_pressed("ui_accept"):
	#	$dungeonGenerator.generate()
	pass

func generateDungeon():
	$dungeonGenerator.generate()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func ascend():
	print("player hit stairs")
	
	$dungeonGenerator.generate()