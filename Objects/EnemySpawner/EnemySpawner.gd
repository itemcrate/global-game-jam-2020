extends Node2D

var Enemy = preload("res://Objects/Enemy/Enemy.tscn")

onready var SpawnPoint = get_node("SpawnPoint");
onready var SpawnTrigger = get_node("SpawnTrigger")

export var spawn_size = 1

var has_spawned = false


# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnTrigger.connect("body_entered", self, "_on_body_entered")

func spawn_enemy(count = 1):

	for _i in range(count):
		# Spawn Player
		var enemy_instance = Enemy.instance()
		var spawn_coord = SpawnPoint.get_global_position()

		spawn_coord.x += rand_range(-10,10);
		spawn_coord.y += rand_range(-10,10);

		enemy_instance.set_position(spawn_coord)
		get_tree().get_current_scene().call_deferred('add_child', enemy_instance)

	has_spawned = true

func _on_body_entered(body):
	if (!self.has_spawned && (body.is_in_group("Player") || body.is_in_group('Vehicle'))):
		spawn_enemy(self.spawn_size)
