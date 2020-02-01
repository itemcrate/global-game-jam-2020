extends KinematicBody2D

export (int) var speed = 50
export (bool) var hasPart = false

# Types: 0 => nothing; 1 => small; 2 => medium; 3 => large
var partType = 1

var velocity = Vector2()
var target = Vector2()

func ai_sense_env():
	target = Vector2(200,100)

#func get_ai_input():
#	velocity = Vector2()
#	velocity.x += 1
#	velocity.y += 1
#	velocity = velocity.normalized() * speed 

func ai_move_toward(_target):
	velocity = _target - self.position
	velocity = velocity.normalized()
	if hasPart:
		if partType == 1:   # small part
			velocity *= (speed * 0.80)
		elif partType == 2: # medium part
			velocity *= (speed * 0.60)
		elif partType == 3: # large part
			velocity *= (speed * 0.40)
	else:
		velocity *= speed
	
	velocity = move_and_slide(velocity)

func _physics_process(delta):
	ai_sense_env()
	ai_move_toward(target)
