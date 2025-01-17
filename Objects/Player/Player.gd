extends KinematicBody2D

onready var AnimationPlayer = get_node("AnimationPlayer")
onready var FixAudioPlayer = get_node("FixAudioPlayer")
onready var Sprite = get_node("Sprite")
onready var LootSprite = get_node("LootSprite")
onready var HitBarrierAudioPlayer = get_node("HitBarrierAudioPlayer")
onready var ray = get_node("RayCast2D")

var held_collectibles: Array = []
var motion: Vector2 = Vector2()
var speed: int = 80
var animation = ""
var attacking = false
var destroying_obstruction = false

func _ready():
	pass
	
func _input(event):
	if (event.is_action_pressed("player_left")) && !self.destroying_obstruction:
		Sprite.set_flip_h(true)
	elif (event.is_action_pressed("player_right")) && !self.destroying_obstruction:
		Sprite.set_flip_h(false)

	if (event.is_action_pressed("player_action")):
		if !attacking:
			self.attacking = true
			self._set_animation("Attack")
			AnimationPlayer.set_speed_scale(4.0)
		
func get_input():
	# Detect up/down/left/right keystate and only move when pressed.
	self.motion = Vector2()

	if (!self.destroying_obstruction):
		if Input.is_action_pressed('player_right'):
			self.motion.x += 1
			ray.set_cast_to(Vector2(16, 0))
		if Input.is_action_pressed('player_left'):
			self.motion.x -= 1
			ray.set_cast_to(Vector2(-16, 0))
		if Input.is_action_pressed('player_down'):
			self.motion.y += 1
			ray.set_cast_to(Vector2(0, 16))
		if Input.is_action_pressed('player_up'):
			self.motion.y -= 1
			ray.set_cast_to(Vector2(0, -16))
		self.motion = self.motion.normalized() * speed
	
	# Set Animation
	if !attacking:
		if (self.motion.length()):
			self._set_animation("Walk")
		else:
			self._set_animation("Idle")

	# Detect collision and obstruction removal
	if Input.is_action_pressed("player_action") && ray.is_colliding():
		var collider = ray.get_collider()
		# When colliding with an obstruction, the action is to remove it
		if collider.is_in_group("Obstructions"):
			collider.damage()
			self.destroying_obstruction = true
			if !HitBarrierAudioPlayer.playing:
				HitBarrierAudioPlayer.play()
		# When colliding with the vehicle, the action is to deposit your collectibles into it
		elif collider.is_in_group("Enemy"):
			collider.on_hit_by_player()
		elif collider.is_in_group("Vehicle"):
			if self.held_collectibles.size() > 0:
				FixAudioPlayer.play()
				for part in self.held_collectibles:
					part.deposit()
				self.held_collectibles = []
				set_parts_sprite("")
	elif Input.is_action_just_released("player_action") && ray.is_colliding() && ray.get_collider().is_in_group("Obstructions"):
		ray.get_collider().stopDamage()
		self.destroying_obstruction = false
	elif !ray.is_colliding():
		self.destroying_obstruction = false

func set_parts_sprite(texturePath: String):
	if (texturePath == ""):
		LootSprite.hide()
		return

	LootSprite.set_texture(load(texturePath))
	LootSprite.show()

func _set_animation(new_animation = ""):
	if (self.animation == new_animation):
		return
		
	self.animation = new_animation
	AnimationPlayer.play(self.animation)

func _physics_process(_delta):
	get_input()
	move_and_slide(self.motion)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == 'Attack':
		self.attacking = false
		self._set_animation("Idle")
		AnimationPlayer.set_speed_scale(2.0)
