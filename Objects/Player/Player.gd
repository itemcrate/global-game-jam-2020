extends KinematicBody2D

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
	if Input.is_action_pressed('player_left'):
		self.motion.x -= 1
	if Input.is_action_pressed('player_down'):
		self.motion.y += 1
	if Input.is_action_pressed('player_up'):
		self.motion.y -= 1
	self.motion = self.motion.normalized() * speed

func _physics_process(delta):
	get_input()
	move_and_slide(self.motion)
