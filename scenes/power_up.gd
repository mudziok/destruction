extends TextureButton

@onready var progress_bar = $"../../DestructionPoints"
@export var cost = 50
@export var wait_time = 1.0

var is_purchasable = false
var is_on_cooldown = false

func can_demolish():
	return is_purchasable and not is_on_cooldown 

func use():
	is_on_cooldown = true
	$Timer.wait_time = wait_time
	$Timer.start()

func _process(delta: float) -> void:
	var max_value = progress_bar.max_value
	var value = progress_bar.destination_value
	
	is_purchasable = value + 1 > cost
	if material:
		material.set_shader_parameter('cooldown', 1.0 - $Timer.time_left / wait_time)
		material.set_shader_parameter('gray_out', 0.0 if is_purchasable else 0.5)
	
	position.y = lerp(position.y, (1.0 - cost/max_value) * 120.0 - 5, delta * 2.0)
	position.x = lerp(position.x,  55.0 - (1.0 - cost/max_value) * 15.0, delta * 2.0)

func _on_timer_timeout() -> void:
	is_on_cooldown = false


func _on_pressed() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
