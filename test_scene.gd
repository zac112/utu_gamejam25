extends Node2D

#{WASTE, PLANE, FOREST, SWAMP, MOUNTAIN, ISLAND}

func _ready() -> void:
	var scene = load("res://landscape.tscn")
	for i in range(-4, -4 + 9):
		for j in range(-3, -3 + 7):    
			var instance = scene.instantiate()
			instance.position = Vector2(100*i, 100*j)
			add_child(instance)
			
	var ui = load("res://assets/ElementButtons/element_buttons.tscn")
	var instance = ui.instantiate()
	add_child(instance)
