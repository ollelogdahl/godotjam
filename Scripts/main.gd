extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var worldnode = $WorldViewport/Viewport/world
onready var worldViewport = $WorldViewport/Viewport
onready var minimapViewport = $minimap/Viewport
onready var minimapCamera = $minimap/Viewport/Camera2D


var tilemap : TileMap
#onready var navigation2d : Navigation2D = $WorldViewport/Viewport/world/Navigation2D
var navigation2d
# Called when the node enters the scene tree for the first time.
func _ready():
	navigation2d = get_node("WorldViewport/Viewport/world/Navigation2D")
	minimapViewport.world_2d = worldViewport.world_2d
	pass # Replace with function body.

func dungeon_is_created():
	if not navigation2d:
		navigation2d = get_node("WorldViewport/Viewport/world/Navigation2D")
	if not minimapCamera:
		minimapCamera = get_node("minimap/Viewport/Camera2D")
	if not minimapViewport:
		minimapViewport = get_node("minimap/Viewport")
	if not worldViewport:
		worldViewport = get_node("WorldViewport/Viewport")
	var tilemaps = navigation2d.get_child(0)
	
	minimapViewport.world_2d = worldViewport.world_2d
	tilemap = tilemaps
	set_minimap()

func set_minimap():
	var rect = tilemap.get_used_rect()
	print(rect.position)
	#minimapCamera.position=rect.position
	#minimapCamera.zoom.x = 10
	#.zoom.y = 10
	#minimapViewport.size = Vector2(300,300)
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass