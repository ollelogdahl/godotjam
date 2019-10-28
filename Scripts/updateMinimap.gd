extends Viewport

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var p1 : Sprite = $P1
onready var p2 : Sprite = $P2

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func update_minimap(p1_pos, p2_pos):
	p1.position = p1_pos
	p2.position = p2_pos

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
