extends TextureProgressBar


var destination_value = 0.0

func _ready() -> void:
	pass

var scale_y = 1.0

func _process(delta: float) -> void:
	if destination_value < value:
		value = destination_value
	else:
		value = lerp(value, destination_value, delta * 2.0)
	scale_y = (max_value / 100.0)
	if $Bars.material:
		$Bars.material.set_shader_parameter('scale_y', scale_y)

func add_points(points: int, color: int) -> void:
	destination_value += points
	if destination_value > max_value:
		max_value = destination_value

func remove_points(points: int) -> void:
	destination_value -= points
