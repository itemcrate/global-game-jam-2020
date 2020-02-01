extends KinematicBody2D

onready var Vehicle = get_parent().get_node("Vehicle")

export (int) var speed = 40	# Max speed of enemy movement
export (bool) var hasPart = false # Is enemey holding a vehicle part?

# Types: 0 => nothing; 1 => small; 2 => medium; 3 => large
var partType = 1

var velocity = Vector2() # Velocity vecotr
var target = Vector2() # Position enemy heads toward

func ai_sense_env():
	target = Vehicle.position

func ai_move_toward(_target, delta):
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

	var collision = move_and_collide(velocity * delta)
	if collision:
		# slide reaction
		velocity = velocity.slide(collision.normal)

		# detect collision object (vehicle? player?)
		if collision.get_collider() == Vehicle:
			on_hit_vehicle()
		else:
			print("Enemy: hit something else")

func _physics_process(delta):
	ai_sense_env()
	ai_move_toward(target, delta)

func on_hit_vehicle():
	print("Enemy: hit vehicle")

func on_hit_player():
	pass