extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.

var devices_index = []
var players = []
var world_node

var player_scene = preload("res://Scenes/PlayerScene.tscn")

func _ready():
	world_node = get_node("../world")
	devices_index = Input.get_connected_joypads()
	
	for i in range(len(devices_index)):
		var player = player_scene.instance()
		player.player_controller_id = i
		players.append(player)
		add_child(player)
		
	if len(devices_index) == 0:
		var player = player_scene.instance()
		player.player_controller_id = 0
		players.append(player)
		add_child(player)
		
		player = player_scene.instance()
		player.player_controller_id = 1
		players.append(player)
		add_child(player)
#		for device in devices:
			
	
	
	pass # Replace with function body.


func _unhandled_input(event):
	if event is InputEventJoypadButton:
		var player_id = event.device
		if event.button_index == JOY_DPAD_LEFT:
			#Check if it is a realese or press down
			if event.is_pressed():
				player_scene[player_id].left_pressed = true
			else:
				player_scene[player_id].left_pressed = false
				
		elif event.button_index == JOY_DPAD_RIGHT:
			if event.is_pressed():
				player_scene[player_id].right_pressed = true
			else:
				player_scene[player_id].right_pressed = false
				
		elif event.button_index == JOY_DPAD_UP:
			if event.is_pressed():
				player_scene[player_id].up_pressed = true
			else:
				player_scene[player_id].up_pressed = false			
		elif event.button_index == JOY_DPAD_DOWN:
			if event.is_pressed():
				player_scene[player_id].down_pressed = true
			else:
				player_scene[player_id].down_pressed = false		
	elif event is InputEventKey:
		if event.scancode == KEY_W:
			if event.is_pressed():
				player_scene[0].up_pressed = true
			else:
				player_scene[0].up_pressed = false
		if event.scancode == KEY_S:
			if event.is_pressed():
				player_scene[0].down_pressed = true
			else:
				player_scene[0].down_pressed = false			
		if event.scancode == KEY_A:
			if event.is_pressed():
				player_scene[0].left_pressed = true
			else:
				player_scene[0].left_pressed = false
		if event.scancode == KEY_D:
			if event.is_pressed():
				player_scene[0].right_pressed = true
			else:
				player_scene[0].right_pressed = false

func _process(delta):
	var movment_vector = Vector2(0,0)
	if Input.is_action_just_pressed("down"):
		movment_vector.y += 1
	if Input.is_action_pressed("up"):
		movment_vector.y += -1
	if Input.is_action_pressed("right"):
		movment_vector.x += 1
	if Input.is_action_pressed("left"):
		movment_vector.x += -1
	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
