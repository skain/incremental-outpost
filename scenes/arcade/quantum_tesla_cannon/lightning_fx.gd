class_name LightningFX

const BRANCHING_CHANCE_PCT := 60.0

static var _branching_comparator := -1.0

## Spawns a complete, fading lightning bolt in global space.
static func spawn_lightning(tree: SceneTree, from_pos: Vector2, to_pos: Vector2, fade_duration: float = 0.5) -> void:
	var container := Node2D.new()
	tree.current_scene.add_child(container)
	
	_build_main_bolt(container, from_pos, to_pos)
	_fade_and_free(tree, container, fade_duration)


static func _build_main_bolt(parent: Node2D, from_pos: Vector2, to_pos: Vector2) -> void:
	var main_points := generate_pixel_points(from_pos, to_pos, 3, 16.0)
	
	# outer glow
	parent.add_child(_create_line(main_points, 6.0, Color("00f0ff")))
	
	# inner core
	parent.add_child(_create_line(main_points, 2.0, Color.WHITE))
	
	_build_branches(parent, main_points)

static func _get_branching_comparator() -> float:
	if _branching_comparator < 0.0:
		_branching_comparator = (100.0 - BRANCHING_CHANCE_PCT) / 100.0
	
	return _branching_comparator

static func _build_branches(parent: Node2D, main_points: Array[Vector2]) -> void:
	if main_points.size() < 4:
		return
		
	for i in range(1, main_points.size() - 2):
		if randf() <= _get_branching_comparator():
			continue
			
		var branch_points := _generate_branch_points(main_points[i], main_points[i + 1])
		parent.add_child(_create_line(branch_points, 2.0, Color("00f0ff")))


static func _generate_branch_points(start: Vector2, next_main_point: Vector2) -> Array[Vector2]:
	var main_dir := (next_main_point - start).normalized()
	var side_angle := deg_to_rad(randf_range(30.0, 70.0) * (1.0 if randf() > 0.5 else -1.0))
	var side_dir := main_dir.rotated(side_angle)
	var branch_end := start + side_dir * randf_range(12.0, 28.0)
	
	return generate_pixel_points(start, branch_end, 2, 6.0)
#endregion


#region Factory & Math Utilities
## Line2D factory helper to enforce pixel-art properties consistently.
static func _create_line(points: Array[Vector2], width: float, color: Color) -> Line2D:
	var line := Line2D.new()
	line.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	line.joint_mode = Line2D.LINE_JOINT_SHARP
	line.width = width
	line.default_color = color
	
	for pt in points:
		line.add_point(pt)
		
	return line


## Pure math: Mid-point displacement algorithm for pixel arc paths.
static func generate_pixel_points(start: Vector2, finish: Vector2, iterations: int, displacement: float) -> Array[Vector2]:
	var points: Array[Vector2] = [start, finish]
	var dir := (finish - start).normalized()
	var normal := Vector2(-dir.y, dir.x)
	var current_disp := displacement

	for i in iterations:
		var next_points: Array[Vector2] = []
		for j in range(points.size() - 1):
			var p1 := points[j]
			var p2 := points[j + 1]
			var mid := (p1 + p2) * 0.5
			
			var offset := normal * randf_range(-current_disp, current_disp)
			mid = (mid + offset).snapped(Vector2.ONE)
			
			next_points.append(p1)
			next_points.append(mid)
		
		next_points.append(points.back())
		points = next_points
		current_disp *= 0.5

	return points


static func _fade_and_free(tree: SceneTree, target: Node2D, duration: float) -> void:
	var tween := tree.create_tween()
	tween.tween_property(target, "modulate:a", 0.0, duration)
	tween.tween_callback(target.queue_free)
#endregion
