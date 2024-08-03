extends TileMapLayer

signal map_cleared()

var explosion_scene = preload("res://scenes/explosion.tscn")

func get_points_in_radius(center: Vector2i, radius: float) -> Array:
	var points_in_radius = []
	var min_x = int((center.x - radius))
	var max_x = int((center.x + radius))
	var min_y = int((center.y - radius))
	var max_y = int((center.y + radius))
	
	for x in range(min_x, max_x + 1):
		for y in range(min_y, max_y + 1):
			var point = Vector2i(x, y)
			if point.distance_to(center) <= radius:
				points_in_radius.append(point)
	
	return points_in_radius

const fill_percent = 0.5

var generation_radius = 0
func generate_city(radius: int) -> void:
	generation_radius = radius
	var roots = get_points_in_radius(Vector2i.ZERO, radius)
	for cell in roots:
		erase_cell(cell)
	
	roots.shuffle()
	
	for cell in roots.slice(0, roots.size() * fill_percent):
		var color = [0,1,2,3,4].pick_random()
		var size = [0,0,0,0,1].pick_random()
		set_cell(cell, 1, Vector2i(color, size))
	
	for i in range(200):
		grow()

func _ready() -> void:
	randomize()

func grow() -> void:
	var used_cells = get_used_cells()
	var possible_cells = get_points_in_radius(Vector2.ZERO, generation_radius)
	
	if used_cells.size() == 0:
		return
		
	var random_cell = used_cells.pick_random()
	
	if is_destroying:
		return
	
	var surrounding_cells = get_surrounding_cells(random_cell)
	
	var source_id = get_cell_source_id(random_cell)
	var color = get_cell_atlas_coords(random_cell).x
	var size = [0,0,0,0,1].pick_random()
	
	for cell in surrounding_cells:
		if possible_cells.find(cell) != -1 and get_cell_source_id(cell) == -1:
			set_cell(cell, source_id, Vector2i(color, size))

func check_empty_map():
	var used_cells = get_used_cells()
	if used_cells.size() == 0:
		map_cleared.emit()

func get_surrounding_cells_full(cell: Vector2i):
	var surrounding_cells = [
		Vector2(cell.x + 1, cell.y - 1),
		Vector2(cell.x + 1, cell.y),
		Vector2(cell.x + 1, cell.y + 1),
		Vector2(cell.x, cell.y - 1),
		Vector2(cell.x, cell.y),
		Vector2(cell.x, cell.y + 1),
		Vector2(cell.x - 1, cell.y - 1),
		Vector2(cell.x - 1, cell.y),
		Vector2(cell.x - 1, cell.y + 1),
	]
	return surrounding_cells
	

func get_surroundings_of_color(starting_cell: Vector2i):
	var queue = [starting_cell]
	var visited_levels = []
	var visited_cells = [starting_cell]
	var currently_visited_level = []
	currently_visited_level.append_array(queue)
	
	var starting_atlas_coords = get_cell_atlas_coords(starting_cell)
	
	while queue.size() > 0:
		var level_size = queue.size()
		for i in range(level_size):
			var cell = queue.pop_front()
			var color = get_cell_atlas_coords(cell).x
			if color == -1:
				continue
			
			var surrounding_cells = get_surrounding_cells(cell)
			for sur_cell in surrounding_cells:
				if get_cell_atlas_coords(sur_cell).x == color and visited_cells.find(sur_cell) == -1:
					visited_cells.append(sur_cell)
					currently_visited_level.append(sur_cell)
					queue.append(sur_cell)
		visited_levels.append(currently_visited_level)
		currently_visited_level = []
	
	return visited_levels

var can_destroy = true
var is_destroying = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("lmb") and can_destroy:
		var mouse_position = get_local_mouse_position()
		var removed_cell = local_to_map(mouse_position)
		
		if get_cell_atlas_coords(removed_cell).x == -1:
			return
			
		can_destroy = false
		$DestroyTimer.wait_time = 1.5
		$DestroyTimer.start()
		
		var groups = get_surroundings_of_color(removed_cell)
		
		is_destroying = true
		
		for group in groups:
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			for cell in group:
				var explosion = explosion_scene.instantiate()
				var color = get_cell_atlas_coords(cell).x
				if color != -1:
					add_child(explosion)
					explosion.position = map_to_local(cell)
					explosion.set_palette(color)
					erase_cell(cell)
		is_destroying = false
		check_empty_map()

func _process(delta: float) -> void:
	$"../Gimball/Label2".text = "%.02f" % $DestroyTimer.time_left
	pass

func _on_timer_timeout() -> void:
	for i in range(5):
		grow()

func _on_round_manager_start_round(radius: int) -> void:
	generate_city(radius)

func _on_destroy_timer_timeout() -> void:
	can_destroy = true
