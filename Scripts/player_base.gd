extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var primary_attack_damage = 10

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
	projectiles_node = get_node("../Projectiles")
	melee_collision = $Melee_Attack/CollisionShape2D
	melee_collision.disabled = true
	pass # Replace with function body.

func _process(delta):	

	var dir = get_input()
	
	if dir != Vector2(0,0):
		fireball_dir = dir
		$Melee_Attack.rotation = dir.angle()
		move_and_slide(dir * player_speed)

func test():
	print("test")
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
	$AnimationPlayer.play("attack")

func secondary_attack():
	$AnimationPlayer.play("ranged_attack")


func spawn_fireball():
	var fireball_node = fireball_scene.instance()
	fireball_node.set_damage(10)
	fireball_node.position = self.global_position
	fireball_node.set_direction(fireball_dir)
	projectiles_node.add_child(fireball_node)
	
func third_attack():
	pass



func _on_Melee_Attack_body_entered(body):
	if body.is_in_group("enemies"):
		body.take_damage(primary_attack_damage)