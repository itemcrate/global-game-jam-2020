extends KinematicBody2D

export (int) var speed = 200

var velocity = Vector2()
var target = Vector2()

func ai_sense_env():
	pass

func get_ai_input():
	velocity = Vector2()
	velocity.x += 1
	velocity.y += 1
	velocity = velocity.normalized() * speed

func move_toward(_target):
	pass

func _physics_process(delta):
	get_ai_input()
	velocity = move_and_slide(velocity)
