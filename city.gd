class_name City extends Node2D


var integrity = 100
var resistance = {
	#	Base ones: tier 0
	GLOBALS.Element_type.FIRE : 1.0,
	GLOBALS.Element_type.AIR : 1.0,
	GLOBALS.Element_type.WATER : 1.0,
	GLOBALS.Element_type.EARTH : 1.0,
#	Discoverable
	GLOBALS.Element_type.PLUAGE : 1.0,
	GLOBALS.Element_type.LIGHTNING : 1.0,
	GLOBALS.Element_type.RADIATION: 1.0,
}
var population = 100

var mouse_inside = false


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and mouse_inside: 
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			print("city clicked")
			#type = landscape_interaction(type, Player.selectedElement)


func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false
