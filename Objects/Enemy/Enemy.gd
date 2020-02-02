extends KinematicBody2D

onready var Vehicle = get_parent().get_node("Vehicle")
onready var ray = $RayCast2D
onready var AnimationPlayer = $AnimationPlayer
onready var loot_sprite = $LootSprite

var animation = ""
var disappearDist = 130
var dropped_part = null
var dropped_part_texture = ""
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
	else:        # running away
		# detect distance from vehicle
		if self.disappearDist < self.position.distance_to(Vehicle.position):
			self.queue_free()

func ai_move_toward(_target, _delta):
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

	# Set Animation
	if (self.velocity.length()):
		self._set_animation("Walk")
	else:
		self._set_animation("Idle")

	# move
	move_and_slide(velocity)

	# detect collision
	if ray.is_colliding():
		if ray.get_collider().is_in_group("Vehicle"):
			on_hit_vehicle()
		if ray.get_collider().is_in_group("Player"):
			on_attack_player()

func _physics_process(delta):
	ai_sense_env()
	ai_move_toward(target, delta)

func on_hit_vehicle():
	if !hasPart:
		# Steal the part, damage the vehicle, and carry the part away
		hasPart = true
		partType = randi() % 3 + 1

		var random_int = randi() % 2 + 1
	
		if partType == self.WEIGHTS.SMALL:
			dropped_part_texture = "res://Resources/Sprites/part-small-" + String(random_int) + ".png"
			loot_sprite.position.y -= 10
		elif partType == self.WEIGHTS.MEDIUM:
			dropped_part_texture = "res://Resources/Sprites/part-medium-" + String(random_int) + ".png"
			loot_sprite.position.y -= 12
		else:
			dropped_part_texture = "res://Resources/Sprites/part-large.png"
			loot_sprite.position.y -= 16
		loot_sprite.set_texture(load(dropped_part_texture))

		WorldState.decrement_vehicle_health(10 * partType) # This is just for dev, with larger weight more obviously affecting HP

		# Set new target (turn around and move far away)
		target = (target - self.position) * -1
		target = target.normalized() * 2000

func on_hit_by_player():
	if hasPart:
		hasPart = false

		dropped_part = load("res://Objects/Collectibles/Parts/Parts.tscn").instance()
		dropped_part.position = self.position
		dropped_part.set_weight(partType)

		self.add_child(dropped_part)

		dropped_part.set_sprite_texture(dropped_part_texture)

	WorldState.increment_enemy_tally()

	self.queue_free()

func on_attack_player():
	# TODO: hit sound
	pass # TODO: stun player

func _set_animation(new_animation = ""):
	if (self.animation == new_animation):
		return
		
	self.animation = new_animation
	AnimationPlayer.play(self.animation)
