extends Node

@onready var timer = $RoundTimer
@onready var label = $"../Gimball/Label"
signal start_round(radius: int)

var current_radius = 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	request_new_round()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# temp xd
	label.text = "%d:%02d" % [floor(timer.time_left / 60), int(timer.time_left) % 60]

func request_new_round():
	start_round.emit(current_radius)
	timer.wait_time = 60.0
	timer.start()

func _on_map_map_cleared() -> void:
	timer.stop()
	await get_tree().create_timer(3.0).timeout
	current_radius += 1
	request_new_round()
