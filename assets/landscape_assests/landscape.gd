class_name Landscape extends Node2D

signal spellOnLandscape
signal spellCast

@export var sprites : Array[Texture2D]

var type = GLOBALS.Landscape_type.WASTE

var location : int

var am_i_city = false

var mouse_inside = false

@export var audioClips : Array[AudioStream]

func _ready():
	$Sprite2D.texture = sprites[type]

func wastes_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting: 
		GLOBALS.Element_type.WATER:
			return GLOBALS.Landscape_type.PLANE
		GLOBALS.Element_type.EARTH: 
			return GLOBALS.Landscape_type.HILL
		_:
			return GLOBALS.Landscape_type.WASTE

func plane_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		GLOBALS.Element_type.WATER:
			return GLOBALS.Landscape_type.FOREST
		GLOBALS.Element_type.FIRE: 
			return GLOBALS.Landscape_type.WASTE
		GLOBALS.Element_type.EARTH: 
			return GLOBALS.Landscape_type.HILL
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
		GLOBALS.Element_type.EARTH: 
			return GLOBALS.Landscape_type.WASTE
		GLOBALS.Element_type.STEAM: 
			Player.availabeElements.get_or_add(GLOBALS.Element_type.PLUAGE)
			return GLOBALS.Landscape_type.SWAMP
		GLOBALS.Element_type.WATER: 
			return GLOBALS.Landscape_type.WATER
		_: 
			return GLOBALS.Landscape_type.SWAMP
			
func mountain_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		GLOBALS.Element_type.FIRE: 
			return GLOBALS.Landscape_type.VOLCANO
		_:
			return GLOBALS.Landscape_type.MOUNTAIN
			
func volcano_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		GLOBALS.Element_type.FIRE: 
			Player.availabeElements.get_or_add(GLOBALS.Element_type.LIGHTNING)
			Player.handle_eruption(location)
			$AudioStreamPlayer2D.stream = audioClips[0]
			$AudioStreamPlayer2D.play()
			
		GLOBALS.Element_type.WATER: 
			Player.availabeElements.get_or_add(GLOBALS.Element_type.STEAM)
			Player.handle_eruption(location)
			$AudioStreamPlayer2D.stream = audioClips[0]
			$AudioStreamPlayer2D.play()
		_: pass
	return GLOBALS.Landscape_type.VOLCANO
			
func hill_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		GLOBALS.Element_type.EARTH: 
			return GLOBALS.Landscape_type.MOUNTAIN
		GLOBALS.Element_type.WATER: 
			return GLOBALS.Landscape_type.SWAMP
		_: 
			return GLOBALS.Landscape_type.HILL

func island_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		GLOBALS.Element_type.FIRE: 
			return GLOBALS.Landscape_type.VOLCANO
		GLOBALS.Element_type.WATER: 
			return GLOBALS.Landscape_type.WATER
		_: 
			return GLOBALS.Landscape_type.ISLAND
			
func water_interaction(impacting) -> GLOBALS.Landscape_type:
	match impacting:
		GLOBALS.Element_type.EARTH: 
			return GLOBALS.Landscape_type.ISLAND
		GLOBALS.Element_type.FIRE: 
			Player.availabeElements.get_or_add(GLOBALS.Element_type.STEAM)
			return GLOBALS.Landscape_type.WATER
		_: 
			return GLOBALS.Landscape_type.WATER

func landscape_interaction(impacted, impacting) -> GLOBALS.Landscape_type:
	if impacting == GLOBALS.Element_type.WATER and location == 48:
		Player.availabeElements.get_or_add(GLOBALS.Element_type.RADIATION)
		if(type == GLOBALS.Landscape_type.MOUNTAIN
		or type == GLOBALS.Landscape_type.VOLCANO
		or type == GLOBALS.Landscape_type.WATER
		):
			return type
		else: 
			return GLOBALS.Landscape_type.WASTE
		
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
		GLOBALS.Landscape_type.HILL:
			return hill_interaction(impacting)
		GLOBALS.Landscape_type.ISLAND:
			return island_interaction(impacting)
		GLOBALS.Landscape_type.WATER:
			return water_interaction(impacting)
		GLOBALS.Landscape_type.VOLCANO:
			return volcano_interaction(impacting)
		_:
			push_error("Invalid impacting element.")
			return GLOBALS.Landscape_type.WASTE

func changeTexture() -> void:
	var length = 0.5
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.TRANSPARENT, length)	
	await get_tree().create_timer(length).timeout
	$Sprite2D.texture = sprites[type]
	tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.WHITE, length)
	print("After timeout")
	
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and mouse_inside: 
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			var new_type = landscape_interaction(type, Player.selectedElement)			
			spellOnLandscape.emit()
			Player.mana -= 1
			
			if new_type != type:
				type = new_type
				changeTexture()
				
			Player.time += 1
			Player.simulate_cities()
			
			
	
func doRadioactive():
	var tween = get_tree().create_tween()
	tween.tween_property($Sprite2D, "modulate", Color.GREEN, 10)	
func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true


func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false
