extends "res://Objects/Collectibles/Collectible.gd"

func _ready():
	pass # Replace with function body.

func collect(entity):
	entity.heldCollectible = self
	.collect(entity)

func deposit():
	WorldState.increment_vehicle_health(10) # This value is totally arbitrary and just for dev purposes
	.deposit()
