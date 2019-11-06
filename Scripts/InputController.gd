extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.

var devices_index = []
var players = []
var world_node

export(NodePath) var world_node_path

var player_scene = preload("res://Scenes/PlayerScene.tscn")

func _ready():

	world_node = get_node(world_node_path)
	devices_index = Input.get_connected_joypads()
	players = world_node.players 
#	for i in range(len(devices_index)):
#		var player = player_scene.instance()
#		player.player_controller_id = i
#		players.append(player)
#
#	if len(devices_index) == 0:
#		var player = player_scene.instance()
#		player.player_controller_id = 0
#		players.append(player)
#
#		player = player_scene.instance()
#		player.player_controller_id = 1
#		players.append(player)

	
	
			
	
	
	pass # Replace with function body.


func _unhandled_input(event):
	if event is InputEventJoypadButton:
		var player_id = event.device
		if event.button_index == JOY_DPAD_LEFT:
			#Check if it is a realese or press down
			if event.is_pressed():
				players[player_id].left_pressed = true
			else:
				players[player_id].left_pressed = false
				
		elif event.button_index == JOY_DPAD_RIGHT:
			if event.is_pressed():
				players[player_id].right_pressed = true
			else:
				players[player_id].right_pressed = false
				
		elif event.button_index == JOY_DPAD_UP:
			if event.is_pressed():
				players[player_id].up_pressed = true
			else:
				players[player_id].up_pressed = false			
		elif event.button_index == JOY_DPAD_DOWN:
			if event.is_pressed():
				players[player_id].down_pressed = true
			else:
				players[player_id].down_pressed = false	
		elif event.button_index == JOY_XBOX_A:
			if event.is_pressed():
				players[player_id].primary_attack()
		elif event.button_index == JOY_XBOX_B:
			if event.is_pressed():
				players[player_id].secondary_attack()
		elif event.button_index == JOY_XBOX_Y:
			if event.is_pressed():
				players[player_id].third_attack()
		
	
	elif event is InputEventKey:
		if event.scancode == KEY_W:
			if event.is_pressed():
				players[0].up_pressed = true
			else:
				players[0].up_pressed = false
		elif event.scancode == KEY_S:
			if event.is_pressed():
				players[0].down_pressed = true
			else:
				players[0].down_pressed = false			
		elif event.scancode == KEY_A:
			if event.is_pressed():
				players[0].left_pressed = true
			else:
				players[0].left_pressed = false
		elif event.scancode == KEY_D:
			if event.is_pressed():
				players[0].right_pressed = true
			else:
				players[0].right_pressed = false
				
				
		elif event.scancode == KEY_UP:
			if event.is_pressed():
				players[1].up_pressed = true
			else:
				players[1].up_pressed = false
		elif event.scancode == KEY_DOWN:
			if event.is_pressed():
				players[1].down_pressed = true
			else:
				players[1].down_pressed = false			
		elif event.scancode == KEY_LEFT:
			if event.is_pressed():
				players[1].left_pressed = true
			else:
				players[1].left_pressed = false
		elif event.scancode == KEY_RIGHT:
			if event.is_pressed():
				players[1].right_pressed = true
			else:
				players[1].right_pressed = false
		elif event.scancode == KEY_F and event.is_pressed():
			players[0].primary_attack()
		elif event.scancode == KEY_G and event.is_pressed():
			players[0].secondary_attack()
		elif event.scancode == KEY_H and event.is_pressed():
			players[0].third_attack()
		elif event.scancode == KEY_J and event.is_pressed():
			players[1].primary_attack()
		elif event.scancode == KEY_K and event.is_pressed():
			players[1].secondary_attack()
		elif event.scancode == KEY_L and event.is_pressed():
			players[0].third_attack()	
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
