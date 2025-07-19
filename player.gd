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

func simulate_cities():
	for city in city_references:
		city.city_idle_tick()
		if city.population <= 0:
			city.city_status = City.CityStatus.DEPOPOLULATED
		if city.integrity <= 0:
			city.city_status = City.CityStatus.DESTROYED
		print("city", city.population, city.integrity , ": ", city.serializeCityStatus(city.city_status))
	print("---tick simulation---")
