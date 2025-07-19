extends Node2D

#{WASTE, PLANE, FOREST, SWAMP, MOUNTAIN, ISLAND}

const width = 7
const height = 7
const startX = -4
const startY = -3

func xy2i(x, y):
	return x + width * y

var cities = {
	xy2i(5, 0) : null
}

func _ready() -> void:
	var landscape = load("res://landscape.tscn")
	var city = load("res://city.tscn")
	
	for i in range(startX, startX + width):
		for j in range(startY, startY + height):    
			if xy2i(i, j) in cities:
				var instance = city.instantiate() 
				instance.position = Vector2(100*i, 100*j)
				add_child(instance)
			else:
				var instance = landscape.instantiate()
				instance.position = Vector2(100*i, 100*j)
				add_child(instance)
			
	var ui = load("res://assets/ElementButtons/element_buttons.tscn")
	var instance : Node2D = ui.instantiate()
	instance.position.x = 400
	instance.position.y = -180
	#add_child(instance)
