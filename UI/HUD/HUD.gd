extends CanvasLayer

onready var hp = $HP
onready var pointer = $pointer

func _ready():
	hp.set_value(WorldState.get_vehicle_health())

func _physics_process(_delta):
	# TODO: Replace `get_global_mouse_position` Vector2 with the position of the goal
	hp.set_value(WorldState.get_vehicle_health())
	pointer.look_at(pointer.get_global_mouse_position())
