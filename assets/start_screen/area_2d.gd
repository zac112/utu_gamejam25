extends Area2D


var mouse_inside = false


func _on_mouse_entered() -> void:
	mouse_inside = true
	


func _on_mouse_exited() -> void:
	mouse_inside = false
	


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.is_pressed() and mouse_inside: 
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			get_tree().change_scene_to_file("res://TestScene.tscn")
