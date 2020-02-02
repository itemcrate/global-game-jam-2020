extends Node

var current_level = 1
var vehicle_health
var vehicle_location
var enemy_tally = 0
var vehicle_critical_threshold = 0.33
var vehicle_excellent_threshold = 0.96

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
		Transition.fade_to("res://Screens/GameOver/GameOver.tscn")
	else:
		self.vehicle_health -= amount

# Vehicle Thresholds
func get_vehicle_critical_threshold():
	return self.vehicle_critical_threshold

func set_vehicle_critical_threshold(threshold):
	self.vehicle_critical_threshold = threshold

func get_vehicle_excellent_threshold():
	return self.vehicle_excellent_threshold

func set_vehicle_excellent_threshold(threshold):
	self.vehicle_excellent_threshold = threshold

# Enemy Tally
func get_enemy_tally():
	return self.enemy_tally

func set_enemy_tally(count: int):
	self.enemy_tally = count

func increment_enemy_tally():
	self.enemy_tally += 1

# Current Level
func get_current_level():
	return self.current_level

func set_current_level(level: int):
	self.current_level = level
