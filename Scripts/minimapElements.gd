extends Node

var children_loaded = false
var children_update_needed = false
var key
onready var shrine = $Shrine
var Crystal
var stair 
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var p1 : Sprite = $P1
onready var p2 : Sprite = $P2
onready var root_node = $"/root/Node"

var key_p
var shrine_p
var crystal_p
var stair_p


# Called when the node enters the scene tree for the first time.
func _ready():
	load_children()

	pass # Replace with function body.

func update_players_minimap(p1_pos, p2_pos):
	p1.position = p1_pos
	p2.position = p2_pos

func update_children_pos():
	key.position = key_p
	shrine.position = shrine_p
	Crystal.position = crystal_p
	stair.position = stair_p

#func _process(delta):
#	if key.position != key_p:
#		update_children_pos()
		
		

func update_elements(key_pos, shrine_pos, crystal_pos, stair_pos):
	if not children_loaded:
		load_children()
	
	if shrine_pos:
		shrine.visible = true
		shrine.position = shrine_pos
	else:
		shrine.visible = false
		
	key.position = key_pos
	Crystal.position = crystal_pos
	stair.position = stair_pos
#	key_p = key_pos
#	shrine_p = shrine_pos
#	crystal_p = crystal_pos
#	stair_p = stair_pos
	
func load_children():
	key = $Key
	shrine = $Shrine	
	stair = $Stair
	Crystal = $Crystal
	children_loaded = true
	for child in get_children():
		child.z_index = 3
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
