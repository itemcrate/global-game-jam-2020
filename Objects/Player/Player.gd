extends KinematicBody2D

onready var ray = $RayCast2D

var motion: Vector2 = Vector2()
var speed: int = 80

func _ready():
	pass
	
func _input(event):
	pass
		
func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	self.motion = Vector2()

	if Input.is_action_pressed('player_right'):
		self.motion.x += 1
		ray.set_cast_to(Vector2(16, 0))
	if Input.is_action_pressed('player_left'):
		self.motion.x -= 1
		ray.set_cast_to(Vector2(-16, 0))
	if Input.is_action_pressed('player_down'):
		self.motion.y += 1
		ray.set_cast_to(Vector2(0, 16))
	if Input.is_action_pressed('player_up'):
		self.motion.y -= 1
		ray.set_cast_to(Vector2(0, -16))
	self.motion = self.motion.normalized() * speed

	# Detect collision and obstruction removal
	if Input.is_action_pressed("player_action") && ray.is_colliding():
		if ray.get_collider().is_in_group("obstructions"):
			ray.get_collider().damage()
		if ray.get_collider().is_in_group("Enemy"):
			ray.get_collider().on_hit_by_player()
	elif Input.is_action_just_released("player_action") && ray.is_colliding() && ray.get_collider().is_in_group("obstructions"):
		ray.get_collider().stopDamage()

func _physics_process(delta):
	get_input()
	move_and_slide(self.motion)
