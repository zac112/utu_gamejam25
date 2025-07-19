class_name Landscape extends Node2D

@export var sprites : Array[Texture2D]

var type = GLOBALS.Landscape_type.WASTE

var mouse_inside = false

func _process(delta: float) -> void:
	$Sprite2D.texture = sprites[type]
	

func wastes_interaction(impacting):
	match impacting: 
		GLOBALS.Element_type.WATER:
			return GLOBALS.Landscape_type.PLANE
		_:
			return GLOBALS.Landscape_type.WASTE
			
			

func plane_interaction(impacting):
	match impacting:
		GLOBALS.Element_type.WATER:
			return GLOBALS.Landscape_type.FOREST
		GLOBALS.Element_type.FIRE: 
			return GLOBALS.Landscape_type.WASTE
		_: 
			return GLOBALS.Landscape_type.PLANE
			
func forest_interaction(impacting):
	match impacting:
		GLOBALS.Element_type.FIRE: 
			return GLOBALS.Landscape_type.WASTE
		GLOBALS.Element_type.WATER: 
			return GLOBALS.Landscape_type.SWAMP
		_: 
			return GLOBALS.Landscape_type.FOREST
			
func swamp_interaction(impacting):
	match impacting:
		_: 
			return GLOBALS.Landscape_type.SWAMP
			
func mountain_interaction(impacting):
	match impacting:
		_: 
			return GLOBALS.Landscape_type.MOUNTAIN
			
func island_interaction(impacting):
	match impacting:
		_: 
			return GLOBALS.Landscape_type.ISLAND

func landscape_interaction(impated, impacting):
	match impacting: 
		GLOBALS.Landscape_type.WASTE: 
			wastes_interaction(impacting)
		GLOBALS.Landscape_type.PLANE:
			plane_interaction(impacting)
		GLOBALS.Landscape_type.FOREST:
			forest_interaction(impacting)
		GLOBALS.Landscape_type.SWAMP:
			swamp_interaction(impacting)
		GLOBALS.Landscape_type.MOUNTAIN:
			mountain_interaction(impacting)
		GLOBALS.Landscape_type.ISLAND:
			island_interaction(impacting)
		_:
			push_error("Invalid impacting element.")


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and mouse_inside: 
		#print(event.position	)
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			type = landscape_interaction(type, Player.selectedElement)
			
			
		

func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true


func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false
