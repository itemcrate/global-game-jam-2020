extends "res://Objects/Collectibles/Collectible.gd"

# Weights for various part types
enum WEIGHTS {
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3
}

var weight: int

func _ready():
	pass # Replace with function body.

func collect(entity):
	entity.held_collectibles.append(self)
	.collect(entity)

func deposit():
	WorldState.increment_vehicle_health(10 * self.weight) # This value is totally arbitrary and just for dev purposes
	.deposit()

func get_weight():
	return self.weight

func set_weight(weight):
	self.weight = weight
