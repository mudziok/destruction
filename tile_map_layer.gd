extends TileMapLayer

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
		var color = [0,1,2,3].pick_random()
		set_cell(cell, 1, Vector2i(color, 0))
	
	for i in range(200):
		grow()

func _ready() -> void:
	randomize()
	generate_city(10)


func grow() -> void:
	var used_cells = get_used_cells()
	var possible_cells = get_points_in_radius(Vector2.ZERO, generation_radius)
	
	if used_cells.size() == 0:
		return
		
	var random_cell = used_cells.pick_random()
	
	if mark_for_deletion_cells.find(random_cell) != -1:
		return
	
	var surrounding_cells = get_surrounding_cells(random_cell)
	
	var source_id = get_cell_source_id(random_cell)
	var atlas_coords = get_cell_atlas_coords(random_cell)
	
	for cell in surrounding_cells:
		if possible_cells.find(cell) != -1 and get_cell_source_id(cell) == -1:
			set_cell(cell, source_id, atlas_coords)

func get_surroundings_of_color(starting_cell: Vector2i):
	var queue = [starting_cell]
	var visited_levels = []
	var visited_cells = []
	var currently_visited_level = []
	
	var starting_atlas_coords = get_cell_atlas_coords(starting_cell)
	
	while queue.size() > 0:
		var level_size = queue.size()
		for i in range(level_size):
			var cell = queue.pop_front()
			var atlas_coords = get_cell_atlas_coords(cell)
		
			if atlas_coords == starting_atlas_coords and atlas_coords != Vector2i(-1, -1):
				var surrounding_cells = get_surrounding_cells(cell)
				if visited_cells.find(cell) == -1:
					visited_cells.append(cell)
					currently_visited_level.append(cell)
					queue.append_array(surrounding_cells)
		visited_levels.append(currently_visited_level)
		currently_visited_level = []
	
	return visited_levels

func get_average(cells: Array):
	var x = 0
	var y = 0
	var size = cells.size()
	
	for c in cells:
		x += c.x
		y += c.y
		
	return Vector2i(int(x / size), int(y / size))
	
var mark_for_deletion_cells = []
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("restart"):
		generate_city(10)
	if event is InputEventMouseButton:
		var mouse_position = get_local_mouse_position()
		var removed_cell = local_to_map(mouse_position)
		var groups = get_surroundings_of_color(removed_cell)
		
		for group in groups:
			mark_for_deletion_cells.append_array(group)
		
		for group in groups:
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			await get_tree().process_frame
			for cell in group:
				erase_cell(cell)
				mark_for_deletion_cells.erase(cell)

func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	for i in range(5):
		grow()
