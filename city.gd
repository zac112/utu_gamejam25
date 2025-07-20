class_name City extends Node2D


@export var sprites : Array[Texture2D]

signal spellOnCity

enum CityStatus {
	NATURAL,
	FIRES,
	FLOODED,
	FOG,
	UNREST,
	CARANTINE,
	IRRADIATED,
	DESTROYED,
	DEPOPOLULATED
}

func serializeCityStatus(city_status) -> String:
	match city_status:
		CityStatus.NATURAL:
			return "NATURAL"
		CityStatus.FIRES:
			return "FIRES"
		CityStatus.FLOODED:
			return "FLOODED"
		CityStatus.UNREST:
			return "UNREST"
		CityStatus.CARANTINE:
			return "CARANTINE"
		CityStatus.IRRADIATED:
			return "IRRADIATED"
		CityStatus.FOG:
			return "FOG"
		CityStatus.DESTROYED:
			return "DESTROYED"
		CityStatus.DEPOPOLULATED:
			return "DEPOPOLULATED"
		_:
			return "??"

var city_status = CityStatus.NATURAL
var am_i_city = true

var integrity : int = 100
var population : int = 100
var just_impacted = false

var carantine_max = 1
var carantime_step = 0

var location : int

var mouse_inside = false

func _ready() -> void:
	$Integrity.value = integrity
	$Population.value = population
	$Integrity.visible = false
	$Population.visible = false

func apply_flat_damage(popul : int, struct : int):
	changeTexture()
	population -= popul
	integrity -= struct

func apply_damage(element_type, pop_mult=1.0, int_mult=1.0) -> void:
	changeTexture()
	var d_population = Player.populationDamage[element_type] * Player.effectiveness[element_type]
	var d_integrity = Player.structuralDamage[element_type] * Player.effectiveness[element_type]
	
	population -= (d_population * pop_mult) as int
	integrity -= (d_integrity * int_mult) as int
	
func city_idle_tick():
	$Integrity.value = integrity
	$Population.value = population
	
	if just_impacted:
		just_impacted = false
		return
		
	match city_status:
		CityStatus.NATURAL:
			pass
		CityStatus.FOG:
			if randi() % 2 == 0:
				city_status = CityStatus.NATURAL
		CityStatus.FIRES:
			apply_damage(GLOBALS.Element_type.FIRE, 0.0, 1.0)
			if randi() % 3 == 0:
				city_status = CityStatus.NATURAL
		CityStatus.FLOODED:
			apply_damage(GLOBALS.Element_type.WATER, 0.3, 0.0)
			if randi() % 4 == 0:
				city_status = CityStatus.NATURAL
		CityStatus.UNREST:
			apply_flat_damage(randi()%10, randi()%10)
			var i = randi() % 5
			if i == 0:
				city_status = CityStatus.NATURAL
			elif i == 1:
				city_status = CityStatus.FIRES
			else:
				pass
		CityStatus.CARANTINE:
			apply_flat_damage(randi()%2, 0)
			if carantime_step == carantine_max:
				carantine_max *= 2
				carantime_step = 0
				city_status = CityStatus.NATURAL
			else:
				carantime_step += 1
		CityStatus.IRRADIATED:
			apply_damage(GLOBALS.Element_type.RADIATION)
			var i = randi() % 10
			if i == 0:
				city_status = CityStatus.NATURAL
			elif i == 1:
				city_status = CityStatus.UNREST
			else:
				pass
		

func impactNatural(element) -> CityStatus:
	apply_damage(element)
	match element:
		GLOBALS.Element_type.FIRE:
			return CityStatus.FIRES
		GLOBALS.Element_type.WATER:
			return CityStatus.FLOODED
		GLOBALS.Element_type.STEAM:
			return CityStatus.FOG
		GLOBALS.Element_type.PLUAGE:
			return CityStatus.CARANTINE
		GLOBALS.Element_type.RADIATION:
			return CityStatus.IRRADIATED
		_:
			return city_status
			
func impactFires(element) -> CityStatus:
	match element:
		GLOBALS.Element_type.FIRE:
			apply_damage(element)
			return CityStatus.FIRES
		GLOBALS.Element_type.WATER:
			Player.availabeElements.get_or_add(GLOBALS.Element_type.STEAM)
			return CityStatus.FOG
		GLOBALS.Element_type.RADIATION:
			apply_damage(element)
			just_impacted = false
			return CityStatus.FIRES
		_:
			apply_damage(element)
			just_impacted = false
			return city_status
			
func impactFog(element) -> CityStatus:
	match element:
		GLOBALS.Element_type.FIRE:
			apply_damage(element)
			return CityStatus.FIRES
		GLOBALS.Element_type.WATER:
			apply_damage(element)
			return CityStatus.FLOODED
		GLOBALS.Element_type.AIR:
			apply_damage(element)
			return CityStatus.NATURAL
		GLOBALS.Element_type.PLUAGE:
			apply_damage(element, 2.0, 2.0)
			return CityStatus.CARANTINE
		GLOBALS.Element_type.LIGHTNING:
			apply_damage(element, 2.0, 1.0)
			return CityStatus.FIRES
		GLOBALS.Element_type.RADIATION:
			apply_damage(element)
			just_impacted = false
			return city_status
		_:
			apply_damage(element)
			just_impacted = false
			return city_status
			
func impactFlooded(element) -> CityStatus:
	match element:
		GLOBALS.Element_type.FIRE:
			apply_damage(element)
			return CityStatus.FIRES
		GLOBALS.Element_type.WATER:
			apply_damage(element)
			return CityStatus.FLOODED
		GLOBALS.Element_type.PLUAGE:
			apply_damage(element, 2.0, 2.0)
			return CityStatus.CARANTINE
		GLOBALS.Element_type.RADIATION:
			apply_damage(element)
			just_impacted = false
			return city_status
		GLOBALS.Element_type.LIGHTNING:
			apply_damage(element, 2.0, 2.0)
			Player.availabeElements.get_or_add(GLOBALS.Element_type.STEAM)
			just_impacted = false
			return city_status
		_:
			apply_damage(element)
			just_impacted = false
			return city_status
			
func impactCarantined(element) -> CityStatus:
	match element:
		GLOBALS.Element_type.FIRE:
			apply_damage(element, 0.5, 0.5)
			return CityStatus.FIRES
		GLOBALS.Element_type.WATER:
			apply_damage(element)
			return CityStatus.FLOODED
		GLOBALS.Element_type.AIR:
			apply_damage(element)
			Player.handle_plague_spread(location)
			just_impacted = false
			return city_status
		GLOBALS.Element_type.PLUAGE:
			apply_damage(element, 0.5, 0.5)
			return CityStatus.CARANTINE
		GLOBALS.Element_type.RADIATION:
			apply_damage(GLOBALS.Element_type.PLUAGE, 3.0, 3.0)
			return CityStatus.IRRADIATED
		_:
			apply_damage(element)
			just_impacted = false
			return city_status
			
func impactUnrested(element) -> CityStatus:
	apply_damage(element)
	match element:
		GLOBALS.Element_type.FIRE:
			return CityStatus.FIRES
		GLOBALS.Element_type.WATER:
			return CityStatus.FLOODED
		GLOBALS.Element_type.PLUAGE:
			return CityStatus.CARANTINE
		GLOBALS.Element_type.RADIATION:
			return CityStatus.IRRADIATED
		_:
			apply_damage(element)
			just_impacted = false
			return city_status
			
			
func impactIrradiated(element) -> CityStatus:
	apply_damage(element)
	match element:
		GLOBALS.Element_type.FIRE:
			return CityStatus.FIRES
		GLOBALS.Element_type.WATER:
			return CityStatus.FLOODED
		GLOBALS.Element_type.PLUAGE:
			return CityStatus.CARANTINE
		GLOBALS.Element_type.RADIATION:
			return CityStatus.IRRADIATED
		_:
			return city_status

#NATURAL, FIRES, FLOODED, UNREST, CARANTINE, IRRADIATED,
func cityImpact(city_status, impacting_element) -> CityStatus:
	match city_status:
		CityStatus.NATURAL:
			return impactNatural(impacting_element)
		CityStatus.FOG:
			return impactFog(impacting_element)
		CityStatus.FIRES:
			return impactFires(impacting_element)
		CityStatus.FLOODED:
			return impactFlooded(impacting_element)
		CityStatus.UNREST:
			return impactUnrested(impacting_element)
		CityStatus.CARANTINE:
			return impactCarantined(impacting_element)
		CityStatus.IRRADIATED:
			return impactIrradiated(impacting_element)
		_: 
			return city_status
			
func handle_eruption() -> void:
	just_impacted = true
	apply_damage(GLOBALS.Element_type.FIRE, 2.0, 2.0)
	match city_status:
		CityStatus.FLOODED:
			pass
		CityStatus.CARANTINE:
			pass
		_: 
			pass
			
	
	city_status = CityStatus.FIRES
	changeTexture()
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed() and mouse_inside: 
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			just_impacted = true
			Player.time += 1
			var new_city_status = cityImpact(city_status, Player.selectedElement)
			
			if new_city_status != city_status:
				city_status = new_city_status
				changeTexture()
				
			
			$Integrity.value = integrity
			$Population.value = population
			
			Player.simulate_cities()
			Player.effectiveness[Player.selectedElement] /= 1.5
			
			
			
			
func changeTexture() -> void:
	var length = 0.5
	var tween = get_tree().create_tween()
	tween.tween_property($CitySprite, "modulate", Color.TRANSPARENT, length)	
	await get_tree().create_timer(length).timeout
	$CitySprite.texture = sprites[city_status]
	$Integrity.visible = true
	$Population.visible = true
	tween = get_tree().create_tween()
	tween.tween_property($CitySprite, "modulate", Color.WHITE, length)
	
	await get_tree().create_timer(length).timeout
	$Integrity.visible = false
	$Population.visible = false
	
	Player.mana -= 1
	spellOnCity.emit()
			
func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true
	$Integrity.visible = true
	$Population.visible = true


func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false
	$Integrity.visible = false
	$Population.visible = false
