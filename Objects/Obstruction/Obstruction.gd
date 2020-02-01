extends StaticBody2D

# This is the abstract / parent class for all types of obstructions in the game. These can include:
# - Barricades laid by the enemy
# - Impassible terrain
# - Destructible terrain

# Shared properties include:
# - decay_bar: A progress bar for tracking decay_time.
# - decay_time: This essentially functions as HP, with time remaining for a destroy action to remove it.
# - is_destructible flag: Can this obstruction be removed in the first place?

onready var decay_bar = $DecayBar
onready var timer = $Timer

var decay_time: float = 3.00
var is_destructible: bool = true

func _ready():
	timer.set_wait_time(decay_time)

# This gets called by the player upon their raycast colliding with obstruction objects
func damage():
	if !is_destructible:
		return

	if timer.is_stopped():
		# Starting the decay procress: start the timer and toggle visibility
		timer.start()
		decay_bar.show()
	elif timer.is_paused():
		decay_bar.show()
		timer.set_paused(false)

	decay_bar.set_value(timer.get_time_left())

# This is called when a user temporarily stops their action/input for removing the obstruction
func stopDamage():
	if !is_destructible:
		return
	# Pause the timer and hide the progress bar
	decay_bar.hide()
	timer.set_paused(true)

func destroy():
	self.queue_free()
