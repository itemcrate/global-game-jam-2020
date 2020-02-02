extends Node2D

onready var Timer = get_node("Timer")

func _ready():
	Timer.connect("timeout", self, "_on_timer_timeout")
	
func _on_timer_timeout():
	Transition.fade_to("res://Screens/Intro/Intro.tscn")


