extends Node2D

func _input(event):
	if (event.is_action_pressed("debug")):
		Transition.fade_to("res://Screens/Sandbox/Sandbox.tscn")
		InfoBox.open("Entering Sandbox")
