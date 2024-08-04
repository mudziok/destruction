extends ColorRect

func _on_ui_bomb_timeout() -> void:
	modulate.a = 1.0
	await get_tree().create_timer(1.0).timeout
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 2.0)
