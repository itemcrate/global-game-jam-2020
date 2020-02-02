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
onready var BattleMusicPlayer = get_node("BattleMusicPlayer")
onready var EnemyDetector = get_node("EnemyDetector")
onready var SmokeParticles = get_node("SmokeParticles")

var motion: Vector2 = Vector2()
var speed = 20
var is_active = false
var nearby_passenger = null
var left_animation = null
var right_animation = null
var enemy_count = 0

const SPEEDS = {
	SLOW = 10,
	NORMAL = 40,
	FAST = 70 
}

func _ready():
	PlayerDetector.connect("body_entered", self, "_on_player_detector_body_entered")
	PlayerDetector.connect("body_exited", self, "_on_player_detector_body_exited")
	EnemyDetector.connect("body_entered", self, "_on_enemy_detector_body_entered")
	EnemyDetector.connect("body_exited", self, "_on_enemy_detector_body_exited")
	
func _input(event):
	if (event.is_action_pressed("vehicle_enter")):
		if (self.is_active):
			self.exit()
		elif (!self.is_active and self.nearby_passenger):
			self.enter()
	
func _physics_process(_delta):
	if (
		WorldState.get_vehicle_health() < 100 * WorldState.get_vehicle_critical_threshold() and
		!SmokeParticles.is_emitting()
	):
		SmokeParticles.set_emitting(true)
	
	if (self.is_active):
		# Set speed based on health
		if WorldState.get_vehicle_health() < 100 * WorldState.get_vehicle_critical_threshold():
			self.speed_slow()
		elif WorldState.get_vehicle_health() > 100 * WorldState.get_vehicle_excellent_threshold():
			self.speed_fast()
		else:
			self.speed_normal()

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
	# Before we enter the vehicle, we have to deposit all held collectibles
	if self.nearby_passenger.held_collectibles.size() > 0:
		for part in self.nearby_passenger.held_collectibles:
			part.deposit()
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

func speed_slow():
	self.speed = self.SPEEDS.SLOW

func speed_normal():
	self.speed = self.SPEEDS.NORMAL

func speed_fast():
	self.speed = self.SPEEDS.FAST

func _on_player_detector_body_entered(body):
	if (!body.is_in_group("Player")):
		return
	
	self.nearby_passenger = body
	
func _on_player_detector_body_exited(body):
	if (!body.is_in_group("Player")):
		return
	
	self.nearby_passenger = null
	
func _on_enemy_detector_body_entered(body):
	if (!body.is_in_group("Enemy")):
		return
	
	self.enemy_count += 1
	
	if (!BattleMusicPlayer.is_playing()):
		BattleMusicPlayer.play()
	
func _on_enemy_detector_body_exited(body):
	if (!body.is_in_group("Enemy")):
		return
	
	self.enemy_count -= 1
	
	if (self.enemy_count == 0):
		BattleMusicPlayer.stop()
