class_name Landscape extends Node2D

# enum Landscape_type {WASTE = 0, PLANE, FOREST, SWAMP, MOUNTAIN, ISLAND}
@export var sprites : Array[Texture2D]

var type = GLOBALS.Landscape_type.WASTE

var mouse_inside = false

func _process(_delta: float) -> void:
	$Sprite2D.texture = sprites[type]
	

func wastes_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting: 
		GLOBALS.Element_type.WATER:
			return GLOBALS.Landscape_type.PLANE
		_:
			return GLOBALS.Landscape_type.WASTE
			
			

func plane_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		GLOBALS.Element_type.WATER:
			return GLOBALS.Landscape_type.FOREST
		GLOBALS.Element_type.FIRE: 
			return GLOBALS.Landscape_type.WASTE
		_: 
			return GLOBALS.Landscape_type.PLANE
			
func forest_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		GLOBALS.Element_type.FIRE: 
			return GLOBALS.Landscape_type.WASTE
		GLOBALS.Element_type.WATER: 
			return GLOBALS.Landscape_type.SWAMP
		_: 
			return GLOBALS.Landscape_type.FOREST
			
func swamp_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		_: 
			return GLOBALS.Landscape_type.SWAMP
			
func mountain_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		_: 
			return GLOBALS.Landscape_type.MOUNTAIN
			
func island_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		_: 
			return GLOBALS.Landscape_type.ISLAND

func landscape_interaction(impacted, impacting) -> GLOBALS.Landscape_type:
	match impacted: 
		GLOBALS.Landscape_type.WASTE: 
			return wastes_interaction(impacting)
		GLOBALS.Landscape_type.PLANE:
			return plane_interaction(impacting)
		GLOBALS.Landscape_type.FOREST:
			return forest_interaction(impacting)
		GLOBALS.Landscape_type.SWAMP:
			return swamp_interaction(impacting)
		GLOBALS.Landscape_type.MOUNTAIN:
			return mountain_interaction(impacting)
		GLOBALS.Landscape_type.ISLAND:
			return island_interaction(impacting)
		_:
			push_error("Invalid impacting element.")
			return GLOBALS.Landscape_type.WASTE


func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and mouse_inside: 
		#print(event.position	)
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			type = landscape_interaction(type, Player.selectedElement)
			
			
		

func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true


func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false
