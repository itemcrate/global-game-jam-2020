extends CanvasLayer

onready var hp = $HP

func _ready():
	hp.set_value(WorldState.get_vehicle_health())

func _physics_process(_delta):
	hp.set_value(WorldState.get_vehicle_health())
