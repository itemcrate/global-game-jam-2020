extends KinematicBody2D

export (int) var speed = 50

var velocity = Vector2()
var target = Vector2()

func ai_sense_env():
	target = Vector2(200,100)

func get_ai_input():
	velocity = Vector2()
	velocity.x += 1
	velocity.y += 1
	velocity = velocity.normalized() * speed

func ai_move_toward(_target):
	velocity = _target - self.position
	velocity = velocity.normalized() * speed
	velocity = move_and_slide(velocity)

func _physics_process(delta):
	ai_sense_env()
	ai_move_toward(target)
