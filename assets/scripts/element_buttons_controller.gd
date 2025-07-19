extends Node2D

@export var checkboxes : Array[CheckBox]
@export var selectedElement : int

func _on_check_box_pressed(element: int) -> void:
	selectedElement = element
	print(element)
