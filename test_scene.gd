class_name Main extends Node2D

const width = 7
const height = 7
const startX = -4
const startY = -3

func xy2i(x, y):
	return (x - startX) + width * (y - startY)

var cities = {
	xy2i(0, 0) : null,
	xy2i(-2, 1) : null,
	xy2i(1, 3) : null,
	xy2i(1, -2) : null,
}

var landscape_map = [
	# row 1
	GLOBALS.Landscape_type.MOUNTAIN,
	GLOBALS.Landscape_type.MOUNTAIN,
	GLOBALS.Landscape_type.MOUNTAIN,
	GLOBALS.Landscape_type.MOUNTAIN,
	GLOBALS.Landscape_type.MOUNTAIN,
	GLOBALS.Landscape_type.MOUNTAIN,
	GLOBALS.Landscape_type.MOUNTAIN,
	# row 2
	GLOBALS.Landscape_type.MOUNTAIN,
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.WASTE,
	GLOBALS.Landscape_type.WASTE,
	# row 3
	GLOBALS.Landscape_type.MOUNTAIN,
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.ISLAND,
	GLOBALS.Landscape_type.PLANE,
	GLOBALS.Landscape_type.PLANE,
	GLOBALS.Landscape_type.WASTE,
	GLOBALS.Landscape_type.WASTE,
	# row 4
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.PLANE,
	GLOBALS.Landscape_type.PLANE,
	GLOBALS.Landscape_type.WASTE,
	GLOBALS.Landscape_type.WASTE,
	GLOBALS.Landscape_type.WASTE,
	# row 5
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.PLANE,
	GLOBALS.Landscape_type.WASTE,
	GLOBALS.Landscape_type.WASTE,
	GLOBALS.Landscape_type.WASTE,
	GLOBALS.Landscape_type.WASTE,
	GLOBALS.Landscape_type.WASTE,
	# row 6
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.PLANE,
	GLOBALS.Landscape_type.SWAMP,
	GLOBALS.Landscape_type.SWAMP,
	GLOBALS.Landscape_type.SWAMP,
	GLOBALS.Landscape_type.FOREST,
	GLOBALS.Landscape_type.FOREST,
	# row 7
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.PLANE,
	GLOBALS.Landscape_type.SWAMP,
	GLOBALS.Landscape_type.SWAMP,
	GLOBALS.Landscape_type.WATER,
	GLOBALS.Landscape_type.WASTE,
	GLOBALS.Landscape_type.FOREST,
]

func _ready() -> void:
	var landscape = load("res://assets/landscape_assests/landscape.tscn")
	var city = load("res://city.tscn")
	$RadioactiveTimer.wait_time = randi_range(60,80)
	$RadioactiveTimer.start()
	Player.field_width = width
	
	var loc = 0
	for i in range(startX, startX + width):
		for j in range(startY, startY + height):    
			if xy2i(i, j) in cities:
				var instance = city.instantiate() 
				instance.position = Vector2(100*i, 100*j)
				instance.location = loc
				Player.city_references.append(instance)
				Player.cells.append(instance)
				add_child(instance)
				
				instance.spellOnCity.connect(spellOnLandscape)
			else:
				var instance = landscape.instantiate()
				instance.position = Vector2(100*i, 100*j)
				instance.location = loc
				if xy2i(i, j) < landscape_map.size():
					instance.type = landscape_map[xy2i(i, j)]
				Player.cells.append(instance)
				add_child(instance)
				if loc == 48:
					$RadioactiveTimer.timeout.connect(instance.doRadioactive)
				
				instance.spellOnLandscape.connect(spellOnLandscape)
			loc += 1
			
	var ui = load("res://assets/ElementButtons/element_buttons.tscn")
	var instance : Node2D = ui.instantiate()
	instance.position.x = 400
	instance.position.y = -180
	
func spellOnLandscape():
	$ElementButtons.playSpellSound()
	var tween = get_tree().create_tween()
	tween.tween_property($TextureProgressBar, "value", Player.mana, 1).from(Player.mana+1)
	var finger = $Finger3
	if finger:
		finger.queue_free()
