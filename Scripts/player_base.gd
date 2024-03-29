extends entity

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var at_shrine = false
var curced_sword_active = false

onready var UI_node = $"/root/Node/UI"
onready var curced_sword_timer = $CurcedSwordTimer
onready var root_node = $"/root/Node"

var normal_attack_damage = 10
var curced_attack_damage = 20

var left_pressed = false
var right_pressed = false
var up_pressed = false
var down_pressed = false
var player_controller_id

var player_speed = 60

var melee_collision

var fireball_dir = Vector2(1,0)

var projectiles_node

var fireball_scene = preload("res://Scenes/Fireball.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	health = 100
	max_health = 100
	regainControl = 10
	
	projectiles_node = get_node("../Projectiles")
	melee_collision = $Melee_Attack/CollisionShape2D
	melee_collision.disabled = true
	pass # Replace with function body.

func _process(delta):	
	if underControl:
		$Sprite.scale = Vector2(1, 1)
		if velocity.length() <= 0.5:
			$AnimationPlayer.play("Idle")
	
		var dir = get_input()
	
		if dir != Vector2(0,0):
			fireball_dir = dir
			$Melee_Attack.rotation = dir.angle()
			
			$curcedattack2d.rotation = dir.angle()
			velocity = dir * player_speed * 1
		
			$AnimationPlayer.play("Move")
func get_input():
	var motion_dir = Vector2()
	if right_pressed:
		motion_dir.x += 1
	if left_pressed:
		motion_dir.x += -1
	if up_pressed:
		motion_dir.y += -1
	if down_pressed:
		motion_dir.y += 1
	
	return motion_dir.normalized()

func primary_attack():
	$AnimationPlayer.stop(true)
	if curced_sword_active:
		$curcedattack2d/Curced_Attack/AnimationPlayer.play("curced_attack")
	else:
		$Melee_Attack/AnimationPlayer.play("Attack")

func secondary_attack():
	$AnimationPlayer.stop(true)
	spawn_fireball()


func spawn_fireball():
	var fireball_node = fireball_scene.instance()
	fireball_node.set_damage(10)
	fireball_node.position = self.global_position
	fireball_node.set_direction(fireball_dir)
	projectiles_node.add_child(fireball_node)
	
func third_attack():
	if at_shrine:
		if not curced_sword_active:
			curced_sword_active = true
			curced_sword_timer.start()
			health = 0.9 * health
			UI_node.update_healthbar(health, max_health, self.name)
		

func takeDamage(damage, attackDirection, fac):
	UI_node.update_healthbar(health, max_health, self.name)
	.takeDamage(damage,attackDirection,fac)

func _on_Melee_Attack_body_entered(body):
	if body.is_in_group("enemies"):
		body.takeDamage(normal_attack_damage, body.global_position - global_position, 1)
	if body.is_in_group("player"):
		if not body == self:
			body.takeDamage(0, body.global_position - global_position, 1.5)


func death():
	# vöerlagra death()
	$AnimationPlayer.play("Death")
	alive = false
	$'..'.playerDied(self)
	
	visible = false
	position -= Vector2(10000, 10000)
	UI_node.update_healthbar(0, max_health, self.name)
	root_node.player_died(self)
	

func _on_CurcedSwordTimer_timeout():
	curced_sword_active = false
	pass # Replace with function body.



func _on_Curced_Attack_body_entered(body):
	if body.is_in_group("enemies"):
		body.takeDamage(curced_attack_damage, body.global_position - global_position, 1)
	if body.is_in_group("player"):
		if not body == self:
			body.takeDamage(0, body.global_position - global_position, 1.5)
	pass # Replace with function body.
