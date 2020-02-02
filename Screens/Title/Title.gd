extends Node2D

func _ready():
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Transition.fade_to("res://Screens/Main/Main.tscn")
