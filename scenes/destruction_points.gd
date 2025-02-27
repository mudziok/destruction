extends ColorRect


var destination_value = 0.0

var value = 0.0
var max_value = 100.0

func _ready() -> void:
	pass

var scale_y = 1.0

func _process(delta: float) -> void:
	if destination_value < value:
		value = lerp(value, destination_value, delta * 10.0)
	else:
		value = lerp(value, destination_value, delta * 5.0)
	scale_y = (max_value / 100.0)
	if material:
		material.set_shader_parameter('progress', value / max_value)
	if $Bars.material:
		$Bars.material.set_shader_parameter('scale_y', scale_y)

func add_points(points: int, color: int) -> void:
	destination_value += points
	if destination_value > max_value:
		max_value = destination_value

func remove_points(points: int) -> void:
	destination_value -= points
