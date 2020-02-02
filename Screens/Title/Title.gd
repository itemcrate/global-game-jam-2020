extends Node2D

onready var TitleAudioPlayer = $TitleAudioPlayer

func _ready():
	TitleAudioPlayer.play()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		Transition.fade_to("res://Screens/Main/Main.tscn")
