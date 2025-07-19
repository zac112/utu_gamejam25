extends CollisionShape2D

func _input_event(event):
	print("I am handling event: {event}")
	if event is InputEventMouseButton:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				print("clicked left")
			if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
				print("clicked right")
