extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func grow() -> void:
	var used_cells = get_used_cells()
	if used_cells.size() == 0:
		return
		
	var random_cell = used_cells.pick_random()
	var surrounding_cells = get_surrounding_cells(random_cell)
	
	var source_id = get_cell_source_id(random_cell)
	var atlas_coords = get_cell_atlas_coords(random_cell)
	
	for cell in surrounding_cells:
		if get_cell_source_id(cell) == -1:
			set_cell(cell, source_id, atlas_coords)

func remove_cell_and_surroundings(cell: Vector2i):
	await get_tree().process_frame
	var surrounding_cells = get_surrounding_cells(cell)
	var original_atlas_coords = get_cell_atlas_coords(cell)
	erase_cell(cell)
	for surrounding_cell in surrounding_cells:
		var atlas_coords = get_cell_atlas_coords(surrounding_cell)
		if atlas_coords == original_atlas_coords and atlas_coords != Vector2i(-1, -1):
			call_deferred("remove_cell_and_surroundings", surrounding_cell)

func remove_cell_group():
	var mouse_position = get_local_mouse_position()
	var removed_cell = local_to_map(mouse_position)
	remove_cell_and_surroundings(removed_cell)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		remove_cell_group()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	for i in range(5):
		grow()
	pass # Replace with function body.
