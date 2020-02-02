extends Area2D

# This is the abstract/parent collectible class. It should not be used directly / instanced as a child scene.
# Instead, each collectible type should extend this.

onready var collider = $Collider
onready var sprite = $Sprite

func _ready():
	pass

# Called when the player picks up this objects.
# In this abstract level, we hide the sprite and disable collision so it seems to disappear.
# We don't queue_free yet so that we can call deposit where necessary.
# Children will implement their own logic before calling `.collect()`
func collect(_entity):
	collider.call_deferred('set_disabled', true)
	sprite.hide()

# Called when the player deposits this object into the vehicle.
func deposit():
	call_deferred('queue_free')

func _on_Collectible_body_entered(body):
	if body.is_in_group("Player"):
		collect(body)
