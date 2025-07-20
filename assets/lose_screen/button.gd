extends Button


func _on_pressed() -> void:
	Player.clear()
	get_tree().change_scene_to_file("res://TestScene.tscn")
	
