extends entityAI

onready var projectileContainer = $'../../Projectiles'

var walkAnim = "Walk"
var attackAnim = "Attack"

func _ready():
	speed = 5
	health = 40
	
	$AnimationPlayer.play("Idle")
	$Sprite.scale= Vector2(1,1)

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

		
func attack():
	var projectile = preload("res://Scenes/shockWave_enemy.tscn").instance()
	
	projectile.position = self.global_position
	projectile.direction = -(position - target.position).normalized()
	projectileContainer.add_child(projectile)

func withinAttackRange():
	if target.global_position.distance_to(self.global_position) < 14:
		return true
	return false

func deleteSelf():
	queue_free()
