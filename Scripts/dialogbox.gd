extends Polygon2D

var dialog_running = false
#var welcome_dialog = ["Welcome traveler", ", good luck finding treasures and exploring the dungeons ahead.", " Attack with A, B and X and remember to brag about your high scoore"]
var whole_welcome_dialog = "Welcome traveler, good luck finding treasures and exploring the dungeons ahead. Attack with A, B and activate things with Y. Remember to brag about your high scoore!"
var shrine_dialog = "Do you want to trade 10% of your health to obtain a sacred sword? You will have the sword for one minute."
var sentance = 0
var vector_array : PoolVector2Array

onready var writingSpeedNode : Timer = $WritingSpeed
onready var deleteTextTimer : Timer = $deleteText

onready var text_label : RichTextLabel = $RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	text_label.bbcode_enabled =true
	set_dialog_box_size(850,90)
	text_label.visible_characters = 0
	welcome_message()
	
	pass # Replace with function body.

func set_dialog_box_size(x,y):
	vector_array.append(Vector2(0,0))
	vector_array.append(Vector2(x,0))
	vector_array.append(Vector2(x,y))
	vector_array.append(Vector2(0,y))
	
	polygon = vector_array
	text_label.rect_size.x = x * 0.8
	text_label.rect_size.y = y * 0.8
	text_label.rect_position.x = x * 0.1
	text_label.rect_position.y = y * 0.1
	
func welcome_message():
	self.visible = true
	dialog_running = true
	text_label.bbcode_text = whole_welcome_dialog
	writingSpeedNode.start()
	

func shrine_message():
	self.visible = true
	if not dialog_running:
		dialog_running = true
		text_label.bbcode_text = shrine_dialog
		writingSpeedNode.start()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_WritingSpeed_timeout():
	text_label.visible_characters += 1
	if text_label.visible_characters == len(text_label.bbcode_text):
		writingSpeedNode.stop()
		deleteTextTimer.start()
		
		
		
	pass # Replace with function body.


func _on_deleteText_timeout():
	deleteTextTimer.stop()
	text_label.visible_characters = 0
	text_label.bbcode_text= ""
	dialog_running = false
	self.visible = false
	pass # Replace with function body.
