extends Node2D

onready var scoreLabel = $Score
onready var WinAudioPlayer = $WinAudioPlayer
onready var Timer = get_node("Timer")

var maxHealth = 100
var finalScore = 0

func _ready():
	Timer.connect("timeout", self, "_on_timer_timeout")
	WinAudioPlayer.play()
	var health = WorldState.get_vehicle_health()
	var enemyTally = WorldState.get_enemy_tally()
	finalScore = health

	# enemy tally bonus
	finalScore += enemyTally * 10

	# health bonuses
	if health < maxHealth * WorldState.get_vehicle_critical_threshold():
		finalScore *= 0.5
	elif health > maxHealth * WorldState.get_vehicle_excellent_threshold():
		finalScore *= 2

	scoreLabel.text = "Score: %s" % finalScore	
	
func _on_timer_timeout():
	Transition.fade_to("res://Screens/Intro/Intro.tscn")
