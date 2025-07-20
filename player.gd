extends Node


@export var selectedElement = GLOBALS.Element_type.WATER;
@export var mana = 100
@export var availabeElements = {
	GLOBALS.Element_type.WATER : null,
	GLOBALS.Element_type.EARTH : null,
	GLOBALS.Element_type.AIR   : null,
	GLOBALS.Element_type.FIRE  : null,
}

@export var time = 0

var effectiveness = {
	#	Base ones: tier 0
	GLOBALS.Element_type.FIRE : 1.0,
	GLOBALS.Element_type.AIR : 1.0,
	GLOBALS.Element_type.WATER : 1.0,
	GLOBALS.Element_type.EARTH : 1.0,
	GLOBALS.Element_type.STEAM : 1.0,
#	Discoverable
	GLOBALS.Element_type.PLUAGE : 1.0,
	GLOBALS.Element_type.LIGHTNING : 1.0,
	GLOBALS.Element_type.RADIATION: 1.0,
}

var structuralDamage = {
	#	Base ones: tier 0
	GLOBALS.Element_type.FIRE : 15.0,
	GLOBALS.Element_type.AIR : 0.0,
	GLOBALS.Element_type.WATER : 20.0,
	GLOBALS.Element_type.EARTH : 3.0,
	GLOBALS.Element_type.STEAM : 0.0,
#	Discoverable
	GLOBALS.Element_type.PLUAGE : 0.0,
	GLOBALS.Element_type.LIGHTNING : 3.0,
	GLOBALS.Element_type.RADIATION: 0.0,
}

var populationDamage = {
	#	Base ones: tier 0
	GLOBALS.Element_type.FIRE : 13.0,
	GLOBALS.Element_type.AIR : 0.0,
	GLOBALS.Element_type.WATER : 10.0,
	GLOBALS.Element_type.EARTH : 3.0,
	GLOBALS.Element_type.STEAM : 0.0,
#	Discoverable
	GLOBALS.Element_type.PLUAGE : 25.0,
	GLOBALS.Element_type.LIGHTNING : 3.0,
	GLOBALS.Element_type.RADIATION: 35.0,
}

var city_references = []
var cells = []

var field_width;

func bounded(x, b=7) -> bool:
	return x >= 0 and x < b
	

func neighbours(i):
	var x = i%field_width
	var y = i/field_width
	
	var n = cells.size();
	
	var n_idx = []
	if bounded(x - 1) and bounded(y - 1):
		n_idx.append((x - 1) + (y - 1) * field_width)
	if bounded(x - 1) and bounded(y):
		n_idx.append((x - 1) + y * field_width)
	if bounded(x - 1) and bounded(y + 1):
		n_idx.append((x - 1) + (y + 1) * field_width)
		
	if bounded(x + 1) and bounded(y - 1):
		n_idx.append((x + 1) + (y - 1) * field_width)
	if bounded(x + 1) and bounded(y):
		n_idx.append((x + 1) + y * field_width)
	if bounded(x + 1) and bounded(y + 1):
		n_idx.append((x + 1) + (y + 1) * field_width)
		
	if bounded(x) and bounded(y - 1):
		n_idx.append(x + (y - 1) * field_width)
	if bounded(x) and bounded(y + 1):
		n_idx.append(x + (y + 1) * field_width)	
	
	var n_city = []
	var n_land = []
	
	for idx in n_idx:
		if idx < 0 or idx >= n:
			continue
			
		var cell = cells[idx]
		if cell.am_i_city:
			n_city.append(cell)
		else:
			n_land.append(cell)
				
	return [n_city, n_land]

func simulate_cities():
	for city in city_references:
		var old_city_status = city.city_status
		
		city.city_idle_tick()
		if city.population <= 0:
			city.city_status = City.CityStatus.DEPOPOLULATED
		if city.integrity <= 0:
			city.city_status = City.CityStatus.DESTROYED
		print("city(", city.population,", " ,city.integrity , "): ", city.serializeCityStatus(city.city_status))
		if old_city_status != city.city_status:
			city.changeTexture()
	print("---tick simulation---")
	
	
func handle_eruption(idx: int):
	if idx < 0 or idx >= cells.size():
		return
	
	var res = neighbours(idx)
	
	var cs = res[0]
	var ls = res[1]
	
	for l in ls:
		if (l.type == GLOBALS.Landscape_type.SWAMP
		 or l.type == GLOBALS.Landscape_type.PLANE
		 or l.type == GLOBALS.Landscape_type.FOREST
		 or l.type == GLOBALS.Landscape_type.HILL
		):
			l.type = GLOBALS.Landscape_type.WASTE
			l.changeTexture()
	
	for c in cs:
		c.handle_eruption()
		

func handle_plague_spread(idx : int) -> void:
	if idx < 0 or idx >= cells.size():
		return
	
	var res = neighbours(idx)
	var ls = res[1]
	
	for l in ls:
		if (l.type == GLOBALS.Landscape_type.WASTE
		 or l.type == GLOBALS.Landscape_type.PLANE
		 or l.type == GLOBALS.Landscape_type.WATER
		 or l.type == GLOBALS.Landscape_type.ISLAND
		 or l.type == GLOBALS.Landscape_type.FOREST
		 or l.type == GLOBALS.Landscape_type.HILL
		):
			l.type = GLOBALS.Landscape_type.SWAMP
			l.changeTexture()	
	
	
