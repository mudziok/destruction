extends Node

@onready var timer = $RoundTimer
@onready var patch = $NinePatchRect

signal start_round(radius: int)
signal round_won

var current_radius = 3.0
var destination_position = Vector2(-64.0, -32.0)
var destination_size = Vector2(144.0, 128.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	request_new_round()

func _process(delta: float) -> void:
	patch.position = lerp(patch.position, destination_position, 0.2)
	patch.size = lerp(patch.size, destination_size, 0.2)

func request_new_round():
	await get_tree().create_timer(1.0).timeout
	start_round.emit(current_radius)

var grow = 0
func _on_map_map_cleared() -> void:
	round_won.emit()
	await get_tree().create_timer(3.0).timeout
	current_radius += 0.5
	grow += 1
	if grow == 4:
		grow = 0
		destination_position -= Vector2(16.0, 16.0)
		destination_size += Vector2(32.0, 32.0)
	request_new_round()
