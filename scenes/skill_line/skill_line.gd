class_name SkillLine extends Line2D


@export var node_a: SkillTreeNode:
	set(v):
		node_a = v
		_update_line()

@export var node_b: SkillTreeNode:
	set(v):
		node_b = v
		_update_line()

func _process(_delta: float) -> void:
	# In the editor, we want the lines to follow nodes if you move them
	if Engine.is_editor_hint():
		_update_line()

func _update_line() -> void:
	if not node_a or not node_b:
		return

	clear_points()

	# We use global_position to find where the nodes are in the "world"
	# Then we use to_local to translate that world spot into the Line2D's local space
	var point_a := to_local(node_a.global_position)
	var point_b := to_local(node_b.global_position)

	add_point(point_a)
	add_point(point_b)

	_update_style()

func _update_style() -> void:
	
	default_color = Color(1.5, 1.0, 0.2, 1.0) # Glowing Amber
	width = 2.0
	# LOGIC: The cable's appearance depends on the nodes it connects
	#if node_a.current_state == SkillTreeNode.State.PURCHASED:
		#if node_b.current_state == SkillTreeNode.State.PURCHASED:
			## Fully powered connection
			#default_color = Color(1.5, 1.0, 0.2, 1.0) # Glowing Amber
			#width = 2.0
		#elif node_b.current_state != SkillTreeNode.State.UNAVAILABLE:
			## Available path, but not yet taken
			#default_color = Color(1.0, 0.7, 0, 1.0) # Standard Amber
			#width = 1.0
	#else:
		## Unpowered / Locked path
		#default_color = Color(0.2, 0.15, 0, 0.5) # Very dark/dim
		#width = 1.0
