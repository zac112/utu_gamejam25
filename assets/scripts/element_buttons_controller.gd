extends Node2D

@export var elements : Array[Node2D] 

func  _ready() -> void:
	for element in elements:
		element.hide()
		
	for i in range(4):
		addAvailableElement(i)
	
func addAvailableElement(element : int) -> void:
	elements[element].show()
	
func _on_check_box_pressed(element: int) -> void:
	Player.selectedElement = element
	print(Player.selectedElement)
