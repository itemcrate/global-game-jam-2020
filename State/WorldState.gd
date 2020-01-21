extends Node

func _ready():
	# Double Window Resolution & Center
	OS.set_window_size(OS.get_window_size() * 4)
	OS.center_window()
