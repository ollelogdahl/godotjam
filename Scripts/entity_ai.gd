extends entity
class_name entityAI

var speed := 15

var awareRange = 128
var target
var path := PoolVector2Array() setget set_path

var canWalk

var player1
var player2

onready var world = $"../../"

func _ready():
	player1 = world.getPlayer1()
	player2 = world.getPlayer2()
	
	$Timer.wait_time = randf() * 0.4
	set_process(false)
	calculatePath()

func walk(delta):
	var nextPos = nextPathNode()
	if canWalk:
		var movement = nextPos - position
		velocity = movement.normalized() * speed * delta * 100
	
func withinAwareRange():
	if target.global_position.distance_to(self.global_position) < awareRange:
		return true
	return false
func isTargetSeen():
	$RayCast2D.cast_to = target.position - position
	if $RayCast2D.is_colliding():
		var col = $RayCast2D.get_collider()
		if not col is KinematicBody2D:
			return false
		if col.get_instance_id() == target.get_instance_id():
			return true
	return false

func set_path(val : PoolVector2Array) -> void:
	path = val
	if val.size() == 0:
		set_process(false)
	else:
		set_process(true)
func calculatePath():
	if player1.global_position.distance_squared_to(self.global_position) < player2.global_position.distance_squared_to(self.global_position):
		target = player1
	else:
		target = player2

	path = world.get_simple_path(self.global_position, target.global_position, false)
	set_path(path)
	
func nextPathNode():
	if len(path) > 0:
		if(position.distance_to(path[0]) < 0.5):
			path.remove(0)
		canWalk = true
		if len(path) > 0:
			return path[0]
	canWalk = false
	return null

func _on_Timer_timeout():
	if not $Timer.wait_time == 0.4:
		$Timer.wait_time = 0.4
	calculatePath()
	pass