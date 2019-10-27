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
var world_nav_node
# Called when the node enters the scene tree for the first time.
func _ready():
	world_nav_node = get_node("WorldViewport/Viewport/world")
	minimapViewport.world_2d = worldViewport.world_2d
	minimapViewport.size = Vector2(300,300)
	pass # Replace with function body.

func dungeon_is_created():
	if not world_nav_node:
		world_nav_node = get_node("WorldViewport/Viewport/world")
	if not minimapCamera:
		minimapCamera = get_node("minimap/Viewport/Camera2D")
	if not minimapViewport:
		minimapViewport = get_node("minimap/Viewport")
	if not worldViewport:
		worldViewport = get_node("WorldViewport/Viewport")
	var tilemaps = world_nav_node.currentTileMap
	
	minimapViewport.world_2d = worldViewport.world_2d
	tilemap = tilemaps
	set_minimap()

func set_minimap():
	var rect = tilemap.get_used_rect()
	print(rect)
	print(rect.position)
	print(rect.end)
	print(rect.size.x * 8)
	print(rect.size.y * 8)
	
	var zoom
	
	var camera_x_offset = 0
	var camera_y_offset = 0
	
	if rect.size.x > rect.size.y:
		zoom = (rect.size.x * 8)/minimapViewport.size.x
		#om x är större än y så måste man flytta kartan uppåt/kameran åt neråt
		var x_times_bigger_than_y = rect.size.x / rect.size.y
		camera_y_offset = minimapViewport.size.y/2 - \
		((minimapViewport.size.y/2) / x_times_bigger_than_y)
		
	else:
		#om y är större än x så måste man flytta kartan åt vänster/kameran åt höger
		zoom = (rect.size.y * 8)/minimapViewport.size.y
		var y_times_bigger_than_x = rect.size.y/ rect.size.x
		camera_x_offset = minimapViewport.size.x/2 - \
		((minimapViewport.size.x/2) / y_times_bigger_than_x)
	
	var camera_x = (rect.position.x *8  + rect.end.x *8 ) /2
	var camera_y = (rect.position.y *8 + rect.end.y *8) /2
	
	
	
	print(zoom)
	minimapCamera.position= Vector2(camera_x,camera_y)
	minimapCamera.zoom = Vector2(zoom,zoom)
	minimapCamera.offset = Vector2(camera_x_offset, camera_y_offset)
	print(minimapCamera.position)
	#minimapCamera.zoom.x = 10
	#.zoom.y = 10
	#minimapViewport.size = Vector2(300,300)
	
	
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass