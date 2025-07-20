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
	$AudioStreamPlayer2D.play()
	print(Player.selectedElement)
	var finger = $"../Finger2"
	if finger:
		finger.queue_free()

func playSpellSound():
	print(elements[Player.selectedElement].name+"/AudioStreamPlayer2D")
	get_node(elements[Player.selectedElement].name+"/AudioStreamPlayer2D").play()
