extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var scorepublisher = preload("res://Scripts/scorePublisher.gd")
onready var scorething = scorepublisher.new()
var team_name = "Guest_Team"

var team_score = 0 
# Called when the node enters the scene tree for the first time.
func update_score(score):
	
	pass
func _ready():
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):

func publishScore():
	scorething.submit(team_name, team_score)
