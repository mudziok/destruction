extends Node2D

var bomb_scene = preload("res://scenes/bomb.tscn")

signal bomb_timeout
signal buy_power_up(name: String)
signal use_brush(name: String, mouse_position: Vector2)

var brush = 'none'

@onready var brushes = {
	'bulldozer': $DestructionPoints/Bulldozer,
	'meteorite': $DestructionPoints/Meteorite,
	'cross': $DestructionPoints/Cross
}

func start_fuse():
	var bomb = bomb_scene.instantiate()
	$BombSlot.add_child(bomb)
	bomb.connect("exploded", bomb_exploded)

func bomb_exploded():
	bomb_timeout.emit()

func _on_game_round_start() -> void:
	start_fuse()
	$DestructionPoints.destination_value = 0.0

func _on_game_round_won() -> void:
	$BombSlot.get_child(0).put_out()
	
	await get_tree().create_timer(2.0).timeout
	$BombSlot.get_child(0).queue_free()

func _on_game_add_points(points: int, color: int) -> void:
	$DestructionPoints.add_points(points, color)

func _on_game_use_points(points: int) -> void:
	brushes[brush].use()
	$DestructionPoints.remove_points(brushes[brush].cost)

func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("lmb"):
		if brushes.has(brush) and brushes[brush].can_demolish():
			var mouse_position = get_local_mouse_position()
			use_brush.emit(brush, mouse_position)

func _process(_delta):
	var hint = brush
	if brushes.has(brush):
		if brushes[brush].is_on_cooldown:
			hint = 'cooldown'
		if not brushes[brush].is_purchasable:
			hint = 'none'
	$Cursor.change_cursor(hint)

func untoggle_all(mask: String):
	for b in brushes:
		if b != mask:
			brushes[b].button_pressed = false

func _on_bulldozer_toggled(toggled_on: bool) -> void:
	if toggled_on:
		untoggle_all('bulldozer')
		brush = 'bulldozer'

func _on_meteorite_toggled(toggled_on: bool) -> void:
	if toggled_on:
		untoggle_all('meteorite')
		brush = 'meteorite'


func _on_cross_toggled(toggled_on: bool) -> void:
	if toggled_on:
		untoggle_all('cross')
		brush = 'cross'
