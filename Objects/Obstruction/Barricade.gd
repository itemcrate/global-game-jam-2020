extends "res://Objects/Obstruction/Obstruction.gd"

func _ready():
	# Override the parent values if required
	decay_time = 5.00
	._ready()

func _on_Timer_timeout():
	.destroy()
