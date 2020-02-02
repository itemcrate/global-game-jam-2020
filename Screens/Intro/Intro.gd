extends Node2D

onready var AnimationPlayer = get_node("AnimationPlayer")
onready var TransitionTimer = get_node("TransitionTimer")

func _ready():
	# Play Default Animation
	AnimationPlayer.play("Default")
	
	# Connect Transition Timer
	TransitionTimer.connect("timeout", self, "_on_transition_timer_timeout")
	
func _input(event):
	if (event.is_action_pressed("ui_accept")):
		Transition.fade_to("res://Screens/Title/Title.tscn")

func _on_transition_timer_timeout():
	Transition.fade_to("res://Screens/Title/Title.tscn")
