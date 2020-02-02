extends "res://Objects/Collectibles/Collectible.gd"

# Weights for various part types
enum WEIGHTS {
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3
}

var weight: int = self.WEIGHTS.LARGE # Default

func _ready():
	pass

func collect(entity):
	entity.held_collectibles.append(self)
	.collect(entity)

func deposit():
	WorldState.increment_vehicle_health(10 * self.weight) # This value is totally arbitrary and just for dev purposes
	.deposit()

func get_weight():
	return self.weight

func set_weight(newWeight: int):
	var part_sprite = ""
	var random_int = randi() % 2 + 1
	print(random_int)

	self.weight = newWeight

	if self.weight == self.WEIGHTS.SMALL:
		part_sprite = load("res://Resources/Sprites/part-small-" + String(random_int) + ".png")
	elif self.weight == self.WEIGHTS.MEDIUM:
		part_sprite = load("res://Resources/Sprites/part-medium-" + String(random_int) + ".png")
	else:
		part_sprite = load("res://Resources/Sprites/part-large.png")
	sprite.set_texture(part_sprite)
