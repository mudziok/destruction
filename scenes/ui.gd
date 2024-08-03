extends Node2D

var bomb_scene = preload("res://scenes/bomb.tscn")

signal bomb_timeout

func start_fuse():
	var bomb = bomb_scene.instantiate()
	$BombSlot.add_child(bomb)
	bomb.connect("exploded", bomb_exploded)

func put_out_fuse():
	pass

func bomb_exploded():
	bomb_timeout.emit()

func _on_game_round_start() -> void:
	start_fuse()
	print("start")

func _on_game_round_won() -> void:
	put_out_fuse()
	$BombSlot.get_child(0).queue_free()
