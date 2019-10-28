extends Panel

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var TIE = $TextInterfaceEngine

# Called when the node enters the scene tree for the first time.
func _ready():
	print_welcome_message()
	pass # Replace with function body.

func print_welcome_message():
	
	TIE.reset()
	
	TIE.buff_text("Welcome traveler", 0.1)
	TIE.buff_silence(1)
	TIE.buff_text(", good luck finding treasures and exploring the dungeons ahead.", 0.1)
	TIE.buff_silence(0.5)
	TIE.buff_text(" Attack with A, B and X and remember to brag about your high scoore", 0,1)
	TIE.set_state(TIE.STATE_OUTPUT)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
