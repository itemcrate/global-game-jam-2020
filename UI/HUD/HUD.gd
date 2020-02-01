extends CanvasLayer

onready var pointer = $pointer

func _ready():
	set_physics_process(true) # Used for updating the arrow's pointing direction

func _physics_process(_delta):
	# TODO: Replace `get_global_mouse_position` Vector2 with the position of the goal
	pointer.look_at(pointer.get_global_mouse_position())
