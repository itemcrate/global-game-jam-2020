extends CanvasLayer

onready var hp = $HP
onready var tween = $Tween

func _ready():
	hp.set_value(WorldState.get_vehicle_health())

func _physics_process(_delta):
	tween.interpolate_property(hp, 'value', hp.value, WorldState.get_vehicle_health(), 0.1, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
