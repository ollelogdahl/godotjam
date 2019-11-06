extends Node

var scores

func _ready():
	#submit("Valoffa", 82)
	pass


func submit(guestName, score):
	guestName.replace(" ", "_")
	if guestName == "":
		$GameJoltAPI.add_score(str(score), int(score), "", "", "Guest_%x" % randi())
	else:
		$GameJoltAPI.add_score(str(score), int(score), "", "", guestName)
	