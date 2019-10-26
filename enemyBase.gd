extends KinematicBody2D

var health = 20
var speed = 25

var walkAnim = "Walk"
var attackAnim = "Attack"
var deathAnim = "Death"

var target
var path := PoolVector2Array() setget set_path

var player1
var player2

onready var nav = $"/root/Node/world/Navigation2D"
onready var world = $"/root/Node/world"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Walk")
	player1 = world.getPlayer1()
	player2 = world.getPlayer2()
	
	_on_Timer_timeout()
	set_process(false)

func _process(delta):
	var nextPos = path[0]
	var movement = nextPos - position
	
	move_and_slide(movement.normalized() * speed)
	
	if(position == path[0]):
		path.remove(0)

func set_path(val : PoolVector2Array) -> void:
	path = val
	if val.size() == 0:
		set_process(false)
	set_process(true)

func _on_Timer_timeout():
	if player1.position.distance_to(self.position) < player2.position.distance_to(self.position):
		target = player1
	else:
		target = player2

	path = nav.get_simple_path(self.global_position, target.global_position)
	set_path(path)
