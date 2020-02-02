extends "res://Objects/Collectibles/Collectible.gd"

onready var PickupAudioPlayer = $PickupAudioPlayer

# Weights for various part types
enum WEIGHTS {
	SMALL = 1,
	MEDIUM = 2,
	LARGE = 3
}

var texture_path: String = ''
export(WEIGHTS) var weight: int = WEIGHTS.SMALL

func _ready():
	var dropped_part_texture = ""
	var random_int = randi() % 2 + 1

	print(weight)
	match (weight):
		WEIGHTS.SMALL:
			dropped_part_texture = "res://Resources/Sprites/part-small-" + String(random_int) + ".png"
		WEIGHTS.MEDIUM:
			dropped_part_texture = "res://Resources/Sprites/part-medium-" + String(random_int) + ".png"
		WEIGHTS.LARGE:
			dropped_part_texture = "res://Resources/Sprites/part-large.png"

	self.set_sprite_texture(dropped_part_texture)
		

func collect(entity):
	if !PickupAudioPlayer.playing:
		PickupAudioPlayer.play()
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
