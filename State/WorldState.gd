extends Node

func _ready():
	# Double Window Resolution & Center
	OS.set_window_size(OS.get_window_size() * 2)
	OS.center_window()

func _input(event):
	if (event.is_action_pressed("fullscreen_toggle")):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())
