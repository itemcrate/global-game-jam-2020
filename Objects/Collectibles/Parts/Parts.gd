extends "res://Objects/Collectibles/Collectible.gd"

# Weights for various part types
enum WEIGHTS {
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3
}

var texture_path: String = ''
var weight: int = self.WEIGHTS.LARGE # Default

func _ready():
	pass

func collect(entity):
	entity.held_collectibles.append(self)
	entity.set_parts_sprite(self.texture_path)
	.collect(entity)

func deposit():
	WorldState.increment_vehicle_health(10 * self.weight) # This value is totally arbitrary and just for dev purposes
	.deposit()

func get_weight():
	return self.weight

func set_weight(newWeight: int):
	self.weight = newWeight

func set_sprite_texture(texturePath: String):
	self.texture_path = texturePath
	sprite.set_texture(load(self.texture_path))
