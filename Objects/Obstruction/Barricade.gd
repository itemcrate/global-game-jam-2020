extends "res://Objects/Obstruction/Obstruction.gd"

func _ready():
	# Override the parent values if required
	decayTime = 5.00
	._ready()

func _on_Timer_timeout():
	.destroy()
