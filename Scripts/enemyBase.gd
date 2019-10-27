extends KinematicBody2D

var health = 20
var speed = 25

var walkAnim = "Walk"
var attackAnim = "Attack"
var deathAnim = "Death"

var pointing_dir = Vector2()
var target
var path := PoolVector2Array() setget set_path

var player1
var player2

onready var world = $"/root/Node/world"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Walk")
	$Sprite.scale= Vector2(1,1)
	player1 = world.getPlayer1()
	player2 = world.getPlayer2()
	
	set_process(false)
	_on_Timer_timeout()
	pass # Replace with function body.

func _process(delta):
	#var nextPos = path[0]
	#var movement = nextPos - position
	#pointing_dir = movement.angle()
	#move_and_slide(movement.normalized() * speed)

	
	#if(position == path[0]):
	#	path.remove(0)
	pass

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

	path = world.get_simple_path(self.global_position, target.global_position)
	set_path(path)
	


func take_damage(damage):
	health -= damage
	
	if health <= 0:
		$AnimationPlayer.play("Death")

func death():
	queue_free()
