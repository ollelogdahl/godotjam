extends KinematicBody2D
class_name entity

var health := 20
var velocity : Vector2 = Vector2(0, 0)

var underControl := true
var alive := true

var regainControl = 1

var deathAnim = "Death"
var takeDamageAnim = "TakeDamage"

func _process(delta):
	move_and_slide(velocity * delta * 100)
	
	velocity *= 0.85 # drag
	if velocity.length() <= regainControl:
		if alive:
			underControl = true
		velocity = Vector2(0, 0)

func takeDamage(damage, attackDirection, fac):
	health -= damage
	underControl = false # tar av kontroll från AI/spelare
	
	velocity = attackDirection.normalized() * 90 * fac
	if health <= 0:
		death()
		velocity *= 1.5 # dubbla fart ifall död
		alive = false
	else:
		$AnimationPlayer.stop(true)
		$AnimationPlayer.play(takeDamageAnim)

func death():
	$AnimationPlayer.play(deathAnim)
		
	# starta timer till att radera objekt
	var t = Timer.new()
	t.set_wait_time(1) # väntar en sekund för death animation
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	queue_free()