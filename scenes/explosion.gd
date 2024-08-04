extends AnimatedSprite2D

var level = 1;

var palettes = [
	preload("res://buildings/pink_palette.tres"),
	preload("res://buildings/piss_palette.tres"),
	preload("res://buildings/blue_palette.tres"),
	preload("res://buildings/brat_palette.tres"),
	preload("res://buildings/purple_palette.tres"),
]

func set_level(_level):
	level = _level
func set_palette(color):
	material.set_shader_parameter("palette", palettes[color])
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_node("AudioStreamPlayer")
	player.pitch_scale = randf_range(0.8, 1.2)
	player.play()
	if level == 2:
		play("level2")
		return
	play("default")
	
	

func _on_animation_finished() -> void:
	queue_free()
