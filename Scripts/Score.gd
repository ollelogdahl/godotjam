extends Label

var paddingLength = 8
var score = 0

func _ready():
	update_score(0)

func update_score(value):
	score = value
	text = ("Score %0*d" % [paddingLength, score])