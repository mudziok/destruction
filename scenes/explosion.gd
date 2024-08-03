extends AnimatedSprite2D

var palettes = [
	preload("res://buildings/pink_palette.tres"),
	preload("res://buildings/piss_palette.tres"),
	preload("res://buildings/blue_palette.tres"),
	preload("res://buildings/brat_palette.tres"),
	preload("res://buildings/purple_palette.tres"),
]

func set_palette(color):
	material.set_shader_parameter("palette", palettes[color])
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()

func _on_animation_finished() -> void:
	queue_free()
