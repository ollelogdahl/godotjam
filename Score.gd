extends Label

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var paddingLength = 8
var score = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	update_score(score)
	pass # Replace with function body.

func update_score(value):
	text = ("Score %0*d" % [paddingLength, value])
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
