extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var dialog_box_node = $"/root/Node/UI/Dialog_box"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_area_body_entered(body):
	if body.is_in_group("player"):
		dialog_box_node.shrine_message()
		body.at_shrine = true
		print("at shrine")
		
	pass # Replace with function body.


func _on_shrine_body_exited(body):
	if body.is_in_group("player"):
		body.at_shrine = false
	pass # Replace with function body.
