extends Node2D

var destination = position
var last_mouse = Vector2.ZERO

func _process(delta: float) -> void:
	position = lerp(position, Vector2(round(destination.x), round((destination.y))), delta * 20.0)
	
	if Input.is_action_pressed("rmb"):
		var difference = get_viewport().get_mouse_position() - last_mouse
		destination -= difference
	
	last_mouse = get_viewport().get_mouse_position()
