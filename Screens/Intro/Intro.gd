extends Node2D

onready var AnimationPlayer = get_node("AnimationPlayer")

func _ready():
	AnimationPlayer.play("Default")
	
func _input(event):
	if (event.is_action_pressed("debug")):
		AnimationPlayer.play("Default")
