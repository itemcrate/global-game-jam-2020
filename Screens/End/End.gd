extends Node2D

onready var scoreLabel = $Score

var maxHealth = 100
var criticalThreshold = 0.25 # bottom 1/4
var excellentTreshold = 0.75 # top 1/4
var finalScore = 0

func _ready():
	var health = WorldState.get_vehicle_health()
	var enemyTally = WorldState.get_enemy_tally()
	finalScore = health

	# enemy tally bonus
	finalScore += enemyTally * 10

	# health bonus
	if health < maxHealth*criticalThreshold: # negative bonus
		finalScore *= 0.5
	elif health > maxHealth*excellentTreshold: # positive bonus
		finalScore *= 2

	scoreLabel.text = "Score: %s" % finalScore
