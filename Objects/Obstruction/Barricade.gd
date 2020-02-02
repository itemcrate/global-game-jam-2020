extends "res://Objects/Obstruction/Obstruction.gd"

var Part = preload("res://Objects/Collectibles/Parts/Parts.tscn")
onready var SpawnPoint = get_node("SpawnPoint")

func _ready():
	# Override the parent values if required
	decay_time = 5.00
	._ready()

func _on_Timer_timeout():
	var coin_flip = 1

	if (coin_flip == 1):
		var part_instance = Part.instance()
		var spawn_coord = SpawnPoint.get_global_position()
		var part_weight = randi() % 2 + 1

		spawn_coord.x += rand_range(-3,3);
		spawn_coord.y += rand_range(-3,3);

		part_instance.set_position(spawn_coord)
		part_instance.set_weight(part_weight)

		get_tree().get_current_scene().call_deferred('add_child', part_instance)

	.destroy()
