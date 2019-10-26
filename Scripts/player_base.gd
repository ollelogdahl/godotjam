extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var left_pressed = false
var right_pressed = false
var up_pressed = false
var down_pressed = false
var player_controller_id

var player_speed = 30
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):	

	var dir = get_input()
	move_and_slide(dir * player_speed)

func test():
	print("test")
func get_input():
	var motion_dir = Vector2()
	if right_pressed:
		motion_dir.x += 1
	if left_pressed:
		motion_dir.x += -1
	if up_pressed:
		motion_dir.y += -1
	if down_pressed:
		motion_dir.y += 1
	
	return motion_dir.normalized()



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
