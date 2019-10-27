extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var text_engine = $Panel/TextInterfaceEngine

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_text():
	text_engine.reset()
	
	text_engine.set_color(Color(1,1,1))
	
	text_engine.buff_text("Welcome traveler", 0.1)
	text_engine.buff_silence(1)
	text_engine.buff_text("would you like to dubble how much score you get?", 0.1)
	text_engine.buff_silence(0.6)
	text_engine.buff_text("well I thought so...", 0.3)
	text_engine.buff_silence(0.3)
	text_engine.buff_text("I can do it for the right price", 0.1)
	text_engine.buff_silence(0.3)
	text_engine.buff_text("do you want to cut your max health in half to dubble all your future score? Press R to accept", 0.1)
	
	text_engine.set_state(text_engine.STATE_OUTPUT)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_area_body_entered(body):
	if body.is_in_group("player"):
		print("at shrine")
		set_text()
	pass # Replace with function body.
