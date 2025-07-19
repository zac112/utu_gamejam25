extends Node2D

@export var checkboxes : Array[CheckBox] 

func _on_check_box_pressed(element: int) -> void:
	Player.selectedElement = element
	print(Player.selectedElement)
