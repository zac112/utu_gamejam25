extends Sprite2D

var counter = 0

func _ready() -> void:
	startMove()
	
func startMove():
	var pos = 0
	print("Started moving")
	while true:
		await get_tree().create_timer(0.1).timeout
		position.y += sin(pos)
		pos += 0.1

var mouse_inside = false
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and mouse_inside:
		queue_free()

func _on_area_2d_mouse_entered() -> void:
	mouse_inside = true

func _on_area_2d_mouse_exited() -> void:
	mouse_inside = false
