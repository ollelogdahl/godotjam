extends 'res:///Scripts/entity.gd'

onready var projectileContainer = $'../../Projectiles'

var speed := 15

var walkAnim = "Walk"
var attackAnim = "Attack"

var target
var path := PoolVector2Array() setget set_path

var player1
var player2

onready var world = $"../../"

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("Walk")
	$Sprite.scale= Vector2(1,1)
	player1 = world.getPlayer1()
	player2 = world.getPlayer2()
	
	$Timer.wait_time = randf() * 0.4
	set_process(false)
	calculatePath()
	pass # Replace with function body.

func _process(delta):
	if underControl:
		# player seen
		var targetSeen = isTargetSeen()
		var withinAwareRange = withinAwareRange()
		var withinAttackRange = withinAttackRange()
	
		if withinAwareRange and not withinAttackRange: # nära, men inte attacknära
			if not $AnimationPlayer.is_playing():
				$AnimationPlayer.play("Walk")
			walk(delta)
		elif withinAttackRange and not targetSeen: # attacknära, men runt hörnet (gå)
			if not $AnimationPlayer.is_playing():
				$AnimationPlayer.play("Walk")
			walk(delta)
		elif withinAttackRange: # attacknära och ser spelaren
			$AnimationPlayer.play("Attack")
		elif not withinAwareRange: # för långt bort
			$AnimationPlayer.play("Idle")

func walk(delta):
	var nextPos = nextPathNode()
	var movement = nextPos - position
	velocity = movement.normalized() * speed * delta * 100
	
		
func attack():
	var fireball = preload("res://Scenes/Fireball_enemy.tscn").instance()
	
	fireball.set_damage(10)
	fireball.fireballSpeed = 60
	fireball.position = self.global_position
	fireball.set_direction(-(position - target.position).normalized())
	
	projectileContainer.add_child(fireball)

func withinAttackRange():
	if target.global_position.distance_to(self.global_position) < 32:
		return true
	return false
func withinAwareRange():
	if target.global_position.distance_to(self.global_position) < 128:
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
	if(position.distance_to(path[0]) < 0.5):
		path.remove(0)
	
	if len(path) != 0:
		return path[0]
	else:
		return null

func _on_Timer_timeout():
	if not $Timer.wait_time == 0.4:
		$Timer.wait_time = 0.4
	calculatePath()
	pass

func deleteSelf():
	queue_free()
