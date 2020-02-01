extends Area2D

func _ready():
	self.connect("body_entered", self, "_on_body_entered")

func _on_body_entered(body):
	Transition.fade_to("res://Screens/End/End.tscn")
