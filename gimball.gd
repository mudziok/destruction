extends Node2D

var destination = Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.is_action_pressed("rmb"):
		destination -= event.relative

func _process(delta: float) -> void:
	position = lerp(position, destination, 0.5)
