extends Node2D

signal round_start
signal round_won

func _on_bomb_timer_timeout():
	pass


func _on_round_manager_start_round(radius: int) -> void:
	round_start.emit()

func _on_round_manager_round_won() -> void:
	round_won.emit()

func _on_ui_bomb_timeout() -> void:
	pass # Replace with function body.
