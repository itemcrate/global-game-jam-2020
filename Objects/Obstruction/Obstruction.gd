extends StaticBody2D

# This is the abstract / parent class for all types of obstructions in the game. These can include:
# - Barricades laid by the enemy
# - Impassible terrain
# - Destructible terrain

# Shared properties include:
# - Decay Time: This essentially functions as HP, with time remaining for a destroy action to remove it.
# - isDescrutible flag: Can this obstruction be removed in the first place?

onready var timer = $Timer

var decayTime: float = 3.00
var isDescrutible: bool = true

func _ready():
	timer.set_wait_time(decayTime)

# This gets called by the player upon their raycast colliding with obstruction objects
func damage():
	if !isDescrutible:
		return

	if timer.is_stopped():
		timer.start()
	elif timer.is_paused():
		timer.set_paused(false)

	print(timer.get_time_left()) # TODO: Remove -- used for dev testing

# This is called when a user temporarily stops their action/input for removing the obstruction
func stopDamage():
	if !isDescrutible:
		return
	timer.set_paused(true)

func destroy():
	self.queue_free()
