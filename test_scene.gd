extends Node2D

#{WASTE, PLANE, FOREST, SWAMP, MOUNTAIN, ISLAND}



func _ready() -> void:
	var scene = load("res://landscape.tscn")
	for n in range(8):    
		var instance = scene.instantiate()
		instance.position = Vector2(100*n, 100*n)
		add_child(instance)
