class_name SkillTreeNode extends Sprite2D

signal skill_tree_node_clicked(node: SkillTreeNode)

@export var skill_node_resource: SkillNodeResource

var current_level := 1


func _ready() -> void:
	_validate_skill_node_resource()
	_register_with_game_manager()
	draw_lines()
	
	
func draw_lines() -> void:
	for node in find_children("*", "SkillTreeNode", true, false):
		var skill_node := node as SkillTreeNode
		if not skill_node: 
			continue # Good practice: skips the node if it isn't a SkillTreeNode
			
		var line := Line2D.new()

		# Vector2.ZERO is (0,0), which is exactly the center of the parent
		line.add_point(Vector2.ZERO) 
		line.add_point(skill_node.position)
		line.z_index = -1

		line.default_color = Color(1.0, 1.0, 1.0, 1.0)
		line.width = 2.0

		add_child(line)


func get_current_cost() -> int:
	#placeholder
	return current_level * skill_node_resource.skill_cost
	
	
func get_current_modifier_value() -> float:
	return skill_node_resource.modifier_values_by_level[current_level]
	
func try_raise_level() -> void:
	if current_level < skill_node_resource.max_level:
		current_level += 1
		

func _register_with_game_manager() -> void:
	GameManager.register_skill_node(self)
	

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		skill_tree_node_clicked.emit(self)
		

func _validate_skill_node_resource() -> void:
	assert(skill_node_resource != null)
	assert(skill_node_resource.max_level > 0)
	assert(skill_node_resource.skill_cost >= 0)
	assert(skill_node_resource.skill_name != null and skill_node_resource.skill_name != "")
	assert(skill_node_resource.max_level == len(skill_node_resource.modifier_values_by_level))
