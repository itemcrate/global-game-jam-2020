extends KinematicBody2D

onready var Vehicle = get_parent().get_node("Vehicle")
onready var ray = $RayCast2D
var rayLength = 10

export (int) var speed = 40	# Max speed of enemy movement
export (bool) var hasPart = false # Is enemey holding a vehicle part?

# Weights for various part types
enum WEIGHTS {
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3
}

# Assign weight value (larger part => slower movement)
const WEIGHT_VALUE = {
	SMALL = 0.8,
	MEDIUM = 0.6,
	LARGE = 0.4
}

# Store current weight
var partType = self.WEIGHTS.SMALL

var velocity = Vector2() # Velocity vecotr
var target = Vector2() # Position enemy heads toward

func ai_sense_env():
	if !hasPart: # target vehicle
		target = Vehicle.position

func ai_move_toward(_target, delta):
	# get vector to target
	velocity = _target - self.position
	velocity = velocity.normalized()
	ray.set_cast_to(velocity * rayLength)

	# determine speed
	if hasPart:
		if partType == self.WEIGHTS.SMALL:
			velocity *= (speed * self.WEIGHT_VALUE.SMALL)
		elif partType == self.WEIGHTS.MEDIUM:
			velocity *= (speed * self.WEIGHT_VALUE.MEDIUM)
		elif partType == self.WEIGHTS.LARGE:
			velocity *= (speed * self.WEIGHT_VALUE.LARGE)
	else:
		velocity *= speed

	# move
	move_and_slide(velocity)

	# detect collision
	if ray.is_colliding():
		if ray.get_collider().is_in_group("Vehicle"):
			on_hit_vehicle()
		if ray.get_collider().is_in_group("Player"):
			on_hit_player()

func _physics_process(delta):
	ai_sense_env()
	ai_move_toward(target, delta)

func on_hit_vehicle():
	if !hasPart:
		# Collect part and decrement vehicle health
		hasPart = true
		partType = randi()%3 + 1 # int from 1 to 3

		WorldState.decrement_vehicle_health(10 * partType) # This is just for dev, with larger weight more obviously affecting HP

		# Set new target (turn around and move far away)
		target = (target - self.position) * -1
		target = target.normalized() * 2000

func on_hit_player():
	if hasPart:
		hasPart = false
		# Drop the part as a collectible and die
		var droppedPart = load("res://Objects/Collectibles/Parts/Parts.tscn").instance()
		droppedPart.position = self.position
		droppedPart.set_weight(partType)
		get_parent().add_child(droppedPart)

		self.queue_free()
	pass
