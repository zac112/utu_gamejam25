class_name Main extends Node2D

const width = 7
const height = 7
const startX = -4
const startY = -3

func xy2i(x, y):
	return (x + startX) + width * (y + startY)

var cities = {
	xy2i(0, 0) : null,
	xy2i(-2, 1) : null,
	xy2i(2, 3) : null,
	xy2i(1, -2) : null,
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
				Player.city_references.append(instance)
			else:
				var instance = landscape.instantiate()
				instance.position = Vector2(100*i, 100*j)
				add_child(instance)
			
	var ui = load("res://assets/ElementButtons/element_buttons.tscn")
	var instance : Node2D = ui.instantiate()
	instance.position.x = 400
	instance.position.y = -180
	
