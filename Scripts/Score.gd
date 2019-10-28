extends Label

var paddingLength = 8

func _ready():
	update_score(0)

func update_score(value):
	text = ("Score %0*d" % [paddingLength, value])