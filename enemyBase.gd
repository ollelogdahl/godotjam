extends KinematicBody2D

var health = 20
var speed = 5

var walkAnim = "Walk"
var attackAnim = "Attack"
var deathAnim = "Death"

var path

var player1
var player2

onready var nav = $"/root/Node/world/Navigation2D"
onready var world = $"/root/Node/world"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Walk")
	player1 = world.getPlayer1()
	player2 = world.getPlayer2()
	pass # Replace with function body.

func _process(delta):
	var target
	
	if player1.position.distance_to(self.position) < player2.position.distance_to(self.position):
		target = player1
	else:
		target = player2
	
	path = nav.get_simple_path(self.position, target.position)
	
	var nextPos = path[0]
	var movement = nextPos - position
	
	move_and_slide(movement.normalized() * speed)
	
	pass