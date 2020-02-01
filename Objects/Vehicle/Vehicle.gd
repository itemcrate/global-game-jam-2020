extends KinematicBody2D

var Player = preload("res://Objects/Player/Player.tscn")

onready var PlayerExitPosition = get_node("PlayerExitPosition")
onready var PlayerDetector = get_node("PlayerDetector")

var motion: Vector2 = Vector2()
var speed = 20
var is_active = false
var nearby_passenger = null

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
		
		if (Input.is_action_pressed("vehicle_reverse")):
			self.motion.y = 1 * (self.speed / 2)
			
		if (Input.is_action_pressed("vehicle_left")):
			self.set_rotation_degrees(self.get_rotation_degrees() - 1)
			
		if (Input.is_action_pressed("vehicle_right")):
			self.set_rotation_degrees(self.get_rotation_degrees() + 1)
		
		self.motion = move_and_slide(self.motion.rotated(self.get_rotation()))

func enter():
	# Enable Vehicle
	self.is_active = true
	self.nearby_passenger.queue_free()

func exit():
	# Disable Vehicle
	self.is_active = false
	
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
