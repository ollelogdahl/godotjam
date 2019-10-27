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

var pathTrg
var targetSeen

onready var world = $"../../"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Walk")
	$Sprite.scale= Vector2(1,1)
	player1 = world.getPlayer1()
	player2 = world.getPlayer2()
	
	set_process(false)
	calculatePath()
	pass # Replace with function body.

func _process(delta):
	if pathTrg < len(path):
		var nextPos = path[pathTrg]
		var movement = nextPos - position
		
		# player seen
		targetSeen = false
		$RayCast2D.cast_to = target.position - position
		if $RayCast2D.is_colliding():
			var col = $RayCast2D.get_collider()
			if col.get_instance_id() == target.get_instance_id():
				targetSeen = true
			
		
		if target.global_position.distance_to(self.global_position) > 32 or not targetSeen:
			move_and_slide(movement.normalized() * speed * delta * 100)
	
		if(position == path[0]):
			path.remove(0)
			pathTrg += 1

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
	pathTrg = 0
	set_path(path)

func _on_Timer_timeout():
	calculatePath()
	pass
	


func take_damage(damage):
	health -= damage
	
	if health <= 0:
		$AnimationPlayer.play("Death")

func death():
	queue_free()
