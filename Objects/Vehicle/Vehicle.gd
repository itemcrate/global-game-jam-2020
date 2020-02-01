extends KinematicBody2D

var motion: Vector2 = Vector2()

func _ready():
	pass
	
func _input(event):
	pass
	
func _process(delta):
	self.motion = Vector2()
	
	if (Input.is_action_pressed("ui_up")):
		self.motion.y = -1
	
	move_and_slide(self.motion)
