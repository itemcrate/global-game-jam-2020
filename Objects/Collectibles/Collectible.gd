extends Area2D

# This is the abstract/parent collectible class. It should not be used directly / instanced as a child scene.
# Instead, each collectible type should extend this (fuel, weapons, etc.)

func _ready():
	pass # Replace with function body.

# Called when the player picks up this objects.
# In this abstract level, we'll simply queue_free this object.
# Children will implement their own logic before calling `.collect()`
func collect():
	self.queue_free()

func _on_Collectible_body_entered(body):
	# You may have to wire this signal up for each child, as I don't think the children receive the signals of their parents.
	collect()
