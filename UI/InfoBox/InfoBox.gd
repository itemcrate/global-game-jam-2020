extends CanvasLayer

onready var CloseTimer = get_node("CloseTimer")
onready var Label = get_node("NinePatchRect/Label")
onready var AnimationPlayer = get_node("NinePatchRect/AnimationPlayer")

func _ready():
	CloseTimer.connect("timeout", self, "close")

func open(message):
	Label.set_text(message)
	AnimationPlayer.play("Fade_In")
	CloseTimer.start()
	
func close():
	AnimationPlayer.play("Fade_Out")
