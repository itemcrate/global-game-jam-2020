extends Node

var vehicle_health
var vehicle_location
var enemy_tally = 0

func _ready():
	# Double Window Resolution & Center
	OS.set_window_size(OS.get_window_size() * 2)
	OS.center_window()
	
	# Initialize Vehicle Health
	self.set_vehicle_health(100)

func _input(event):
	if (event.is_action_pressed("fullscreen_toggle")):
		OS.set_window_fullscreen(!OS.is_window_fullscreen())

# Vehicle Location
func get_vehicle_location():
	return self.vehicle_location

func set_vehicle_location(location):
	self.vehicle_location = location

# Vehicle Health
func get_vehicle_health():
	return self.vehicle_health

func set_vehicle_health(health):
	self.vehicle_health = health
	
func increment_vehicle_health(amount):
	if ((self.vehicle_health + amount) > 100):
		self.vehicle_health = 100
	else:
		self.vehicle_health += amount
	
func decrement_vehicle_health(amount):
	if ((self.vehicle_health - amount) < 0):
		self.vehicle_health = 0
	else:
		self.vehicle_health -= amount

# Enemy Tally
func get_enemy_tally():
	return self.enemy_tally

func set_enemy_tally(count):
	self.enemy_tally = count

func increment_enemy_tally():
	self.enemy_tally += 1
