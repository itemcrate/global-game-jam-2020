extends CanvasLayer

var current_scene = null
var path = ""

func _ready():
	var root = get_tree().get_root()
	self.current_scene = root.get_child(root.get_child_count() - 1)

func fade_to(scene_path):
	self.path = scene_path
	get_node("AnimationPlayer").play("Fade")
	
func change_scene():
	if (self.path != ""):
		call_deferred("_deferred_change_scene", self.path) 
		
func _deferred_change_scene(scene_path):
	# Safely Remove Current Scene
	self.current_scene.free()
	
	# Load New Scene
	var new_scene = ResourceLoader.load(scene_path)
	
	# Instance New Scene
	self.current_scene = new_scene.instance()
	
	# Reset Viewport
	get_viewport().set_canvas_transform(Transform2D())
	
	# Add New Scene To Tree
	get_tree().get_root().add_child(self.current_scene)
	
	# Make It Compatible With SceneTree API (Optional)
	get_tree().set_current_scene(self.current_scene)