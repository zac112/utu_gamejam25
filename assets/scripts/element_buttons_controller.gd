extends Node2D

@export var elements : Array[Node2D] 


#FIRE,
#AIR,
#WATER,
#EARTH,
#STEAM,
#PLUAGE,
#LIGHTNING,
#RADIATION,

func  _ready() -> void:
	for element in elements:
		element.hide()
		
	for i in Player.availabeElements.keys():
		addAvailableElement(i)
	
	
func _process(_delta: float) -> void:
	for i in Player.availabeElements.keys():
		addAvailableElement(i)
	
func addAvailableElement(element : int) -> void:
	elements[element].show()
	
func _on_check_box_pressed(element: int) -> void:
	Player.selectedElement = (element as GLOBALS.Element_type)
	print(Player.selectedElement)
