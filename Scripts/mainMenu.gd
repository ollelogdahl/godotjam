extends Control

var score_board
var score_publisher
var name_field
var popup_label : Label

func _ready():
	OS.set_borderless_window(false)
	
	name_field = $NameField
	score_board = $Scoreboard
	score_publisher = $scorePublisher
	popup_label = $badUsername
	score_board.getScores()
	if global.team_score!= 0:
		print("hi")
		print(global.team_name)
		score_publisher.submit(global.team_name, global.team_score)
	$wait_to_update.start()
		
		
#func _on_TextureButton_pressed():
#	var team_name = name_field.text
#	if len(team_name) <= 0:
#		popup_label.visible = true
#		popup_label.text = "Please enter a team name"
#	elif len(team_name) >= 9:
#		popup_label.visible = true
#		popup_label.text = "Team name is too long"
#	else:
#	# byt till spelscenen!
#		global.team_name = name_field.text
#		get_tree().change_scene("res://Scenes/main.tscn")
#
	

func _on_wait_to_update_timeout():
	score_board.getScores()
	pass # Replace with function body.


func _on_NameField_focus_entered():
	print("hi")
	if name_field.text == "Enter your name":
		name_field.text == "9"
	pass # Replace with function body.


func _on_Button_pressed():
	var team_name = name_field.text
#	if len(team_name) <= 0:
#		popup_label.visible = true
#		popup_label.text = "Please enter a team name"
	if len(team_name) >= 9:
		popup_label.visible = true
		popup_label.text = "Team name is too long"
	else:
	# byt till spelscenen!
		global.team_name = name_field.text
		get_tree().change_scene("res://Scenes/main.tscn")
	pass # Replace with function body.
