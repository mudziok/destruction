extends Node

@onready var timer = $RoundTimer

signal start_round(radius: int)
signal round_won

var current_radius = 2.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	request_new_round()
	pass # Replace with function body.

func request_new_round():
	start_round.emit(current_radius)

func _on_map_map_cleared() -> void:
	round_won.emit()
	await get_tree().create_timer(3.0).timeout
	current_radius += 1
	request_new_round()
