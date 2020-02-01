extends KinematicBody2D

var Player = preload("res://Objects/Player/Player.tscn")

onready var PlayerExitPosition = get_node("PlayerExitPosition")
onready var PlayerDetector = get_node("PlayerDetector")
onready var LeftTreadAnimationPlayer = get_node("LeftTread/AnimationPlayer")
onready var RightTreadAnimationPlayer = get_node("RightTread/AnimationPlayer")
onready var BodyAnimationPlayer = get_node("Body/AnimationPlayer")
onready var EngineIdleAmbiencePlayer = get_node("EngineIdleAmbiencePlayer")
onready var EngineStartSoundPlayer = get_node("EngineStartSoundPlayer")
onready var EngineStopSoundPlayer = get_node("EngineStopSoundPlayer")
onready var LeftTreadParticles2D = get_node("LeftTread/Particles2D")
onready var RightTreadParticles2D = get_node("RightTread/Particles2D")

var motion: Vector2 = Vector2()
var speed = 20
var is_active = false
var nearby_passenger = null
var left_animation = null
var right_animation = null

func _ready():
	PlayerDetector.connect("body_entered", self, "_on_player_detector_body_entered")
	PlayerDetector.connect("body_exited", self, "_on_player_detector_body_exited")
	
func _input(event):
	if (event.is_action_pressed("vehicle_enter")):
		if (self.is_active):
			self.exit()
		elif (!self.is_active and self.nearby_passenger):
			self.enter()
	
func _physics_process(_delta):
	if (self.is_active):
		self.motion = Vector2()
		
		if (Input.is_action_pressed("vehicle_forward")):
			self.motion.y = -1 * self.speed
			self._set_animation("Forward", "Forward")
		elif (Input.is_action_pressed("vehicle_reverse")):
			self.motion.y = 1 * (self.speed / 2)
			self._set_animation("Reverse", "Reverse")
			
		if (Input.is_action_pressed("vehicle_left")):
			self.set_rotation_degrees(self.get_rotation_degrees() - 1)
			self._set_animation("Reverse", "Forward")
			
		if (Input.is_action_pressed("vehicle_right")):
			self.set_rotation_degrees(self.get_rotation_degrees() + 1)
			self._set_animation("Forward", "Reverse")
		
		if (
			Input.is_action_just_released("vehicle_forward") or
			Input.is_action_just_released("vehicle_reverse") or
			Input.is_action_just_released("vehicle_left") or
			Input.is_action_just_released("vehicle_right")
		):
			self._set_animation()
		
		self.motion = move_and_slide(self.motion.rotated(self.get_rotation()))
		
func _set_animation(new_left_animation = "", new_right_animation = ""):
	# Reset When No Animations Provided
	if (
		new_left_animation == "" and
		new_right_animation == ""
	):
		LeftTreadAnimationPlayer.stop()
		RightTreadAnimationPlayer.stop()
		self.left_animation = ""
		self.right_animation = ""
		return
	
	# Prevent Playing Same Animation 
	if (
		self.left_animation == new_left_animation and
		self.right_animation == new_right_animation
	):
		return
	
	# Update Current Animation
	self.left_animation = new_left_animation
	self.right_animation = new_right_animation
	
	# Set Animations
	LeftTreadAnimationPlayer.play(self.left_animation)
	RightTreadAnimationPlayer.play(self.right_animation)
	
	# Set Animation Speed Scale
	if (
		self.left_animation == "Reverse" and
		self.right_animation == "Reverse"
	):
		LeftTreadAnimationPlayer.set_speed_scale(0.75)
		RightTreadAnimationPlayer.set_speed_scale(0.75)
	else:
		LeftTreadAnimationPlayer.set_speed_scale(1.5)
		RightTreadAnimationPlayer.set_speed_scale(1.5)
		
func enter():
	# Enable Vehicle
	self.is_active = true
	self.nearby_passenger.queue_free()
	
	# Start Animation
	BodyAnimationPlayer.play("Default")
	
	# Start Audio
	EngineStartSoundPlayer.play()
	EngineIdleAmbiencePlayer.play()
	
	# Start Particles
	LeftTreadParticles2D.set_emitting(true)
	RightTreadParticles2D.set_emitting(true)

func exit():
	# Disable Vehicle
	self.is_active = false
	
	# Stop Animation
	BodyAnimationPlayer.stop()
	
	# Audio
	EngineStopSoundPlayer.play()
	EngineIdleAmbiencePlayer.stop()
	
	# Stop Particles
	LeftTreadParticles2D.set_emitting(false)
	RightTreadParticles2D.set_emitting(false)
	
	# Spawn Player
	var player_instance = Player.instance()
	player_instance.set_position(PlayerExitPosition.get_global_position())
	get_tree().get_current_scene().add_child(player_instance)
	
func _on_player_detector_body_entered(body):
	if (!body.is_in_group("Player")):
		return
	
	self.nearby_passenger = body
	
func _on_player_detector_body_exited(body):
	if (!body.is_in_group("Player")):
		return
	
	self.nearby_passenger = null
