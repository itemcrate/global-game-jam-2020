extends KinematicBody2D

onready var Vehicle = get_parent().get_node("Vehicle")
onready var Player = get_parent().get_node("Player")
onready var ray = $RayCast2D
var rayLength = 16

export (int) var speed = 40	# Max speed of enemy movement
export (bool) var hasPart = false # Is enemey holding a vehicle part?

# Types: 0 => nothing; 1 => small; 2 => medium; 3 => large
var partType = 0

var velocity = Vector2() # Velocity vecotr
var target = Vector2() # Position enemy heads toward

func ai_sense_env():
	if !hasPart: # target vehicle
		target = Vehicle.position
	else:        # already running away
		pass

func ai_move_toward(_target, delta):
	# get vector to target
	velocity = _target - self.position
	velocity = velocity.normalized()
	ray.set_cast_to(velocity * rayLength)

	# determine speed
	if hasPart:
		if partType == 1:   # small part
			velocity *= (speed * 0.80)
		elif partType == 2: # medium part
			velocity *= (speed * 0.60)
		elif partType == 3: # large part
			velocity *= (speed * 0.40)
	else:
		velocity *= speed

	# move
	move_and_slide(velocity)

	# detect collision
	if ray.is_colliding():
		if ray.get_collider() == Vehicle:
			on_hit_vehicle()
		if ray.get_collider() == Player:
			on_hit_player()
		else:
			#print("Enemy: hit something else")
			pass

func _physics_process(delta):
	ai_sense_env()
	ai_move_toward(target, delta)

func on_hit_vehicle():
	if !hasPart:
		# collect part
		hasPart = true
		partType = randi()%3+1 # int from 1 to 3
		#print("Enemy: hit vehicle")
		#print(partType)

		# Set new target (turn around and move far away)
		target = (target - self.position) * -1
		target = target.normalized() * 2000
		# TODO: collect part from vehicle

func on_hit_player():
	if hasPart:
		hasPart = false
		# TODO: die & drop part
	pass
