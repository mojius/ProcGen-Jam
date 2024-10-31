extends Node

func _enter_tree():
	var camera_found := false
	for node in get_tree().current_scene.get_children():
		if node is Camera2D:
			camera_found = true
			break
	if not camera_found:
		var cam = Camera2D.new()
		cam.position = Vector2.ZERO
		cam.current = true
		get_tree().current_scene.add_child(cam)
	
