extends KinematicBody2D

var motion: Vector2 = Vector2()
var speed: int = 20

func _ready():
	pass
	
func _input(_event):
	pass
	
func _physics_process(_delta):
	self.motion = Vector2()
	
	if (Input.is_action_pressed("vehicle_forward")):
		self.motion.y = -1 * self.speed
	
	if (Input.is_action_pressed("vehicle_reverse")):
		self.motion.y = 1 * self.speed
		
	if (Input.is_action_pressed("vehicle_left")):
		self.set_rotation_degrees(self.get_rotation_degrees() - 1)
		
	if (Input.is_action_pressed("vehicle_right")):
		self.set_rotation_degrees(self.get_rotation_degrees() + 1)
	
	move_and_slide(self.motion.rotated(self.get_rotation()))
