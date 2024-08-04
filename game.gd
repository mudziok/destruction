extends Node2D

signal round_start
signal round_won
signal add_points(points: int, color: int)
signal use_points(points: int)
signal change_brush(brush)
signal use_brush(brush: String, mouse_posiiton: Vector2)
signal round_lost()

func _on_bomb_timer_timeout():
	pass

func _on_round_manager_start_round(radius: int) -> void:
	round_start.emit()

func _on_round_manager_round_won() -> void:
	round_won.emit()

func _on_ui_bomb_timeout() -> void:
	round_lost.emit()

func _on_map_add_destruction_points(points: Variant, color: Variant) -> void:
	add_points.emit(points, color)

func _on_ui_buy_power_up(name: String) -> void:
	change_brush.emit(name)

func _on_map_use_points(points: int) -> void:
	use_points.emit(points)

func _on_ui_use_brush(name: String, mouse_position: Vector2) -> void:
	use_brush.emit(name, mouse_position)
