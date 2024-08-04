extends Sprite2D

@onready var hints = {
	'bulldozer': $Bulldozer,
	'meteorite': $Dynamite,
	'cross': $Cross,
	'cooldown': $Cooldown
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func change_cursor(hint: String):
	for c in get_children():
		c.visible = false
	if hints.has(hint):
		hints[hint].visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var mouse_position = get_global_mouse_position()
	position = Vector2(round(mouse_position.x), round(mouse_position.y))
