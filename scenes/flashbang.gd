extends ColorRect


func flash():
	print("XD")
	color.a = 1.0
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
