extends Node2D

onready var tutorial_barricade = $Level1/BarricadeTutorial
onready var tutorial_enemy = $Enemy

var is_tutorial = true
var has_picked_up = false
var has_entered_vehicle = false
var has_entered_barrier = false

func _ready():
	tutorial_barricade.connect("body_entered", self, "_on_tutorial_barricade_body_entered")
	InfoBox.CloseTimer.set_wait_time(1.5)
	InfoBox.open("Attack with A!")

func _physics_process(_delta):
	if self.is_tutorial && !self.has_picked_up:
		if get_node("Player").held_collectibles.size() == 1:
			self.has_picked_up = true
			InfoBox.open("Enter vehicle with Y!")

func _on_Enemy_tree_exited():
	InfoBox.open("Pick up the part!")

func _on_Player_tree_exited():
	if self.is_tutorial && !self.has_entered_vehicle:
		self.has_entered_vehicle = true
		InfoBox.open("Exit vehicle with Y!")

func _on_tutorial_barricade_body_entered(body):
	if self.has_entered_barrier || !body.is_in_group("Player"):
		return

	self.has_entered_barrier = true
	InfoBox.open("Break barriers by holding A!")
