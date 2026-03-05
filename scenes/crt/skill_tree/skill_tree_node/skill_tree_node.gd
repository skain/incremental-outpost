class_name SkillTreeNode extends Sprite2D

enum SkillNodeStatus {UNREVEALED, UNAFFORDABLE, AFFORDABLE, PURCHASED}

signal skill_tree_node_clicked(node: SkillTreeNode)

@export var skill_node_resource: SkillNodeResource

const COLOR_MODULATOR_UNAVAILABLE := Color(1.0, 1.0, 1.0, 0.0)
const COLOR_MODULATOR_UNAFFORDABLE := Color(0.75, 0.75, 0.75, 1.0)
const COLOR_MODULATOR_AFFORDABLE := Color(1.75, 1.75, 1.75, 1.0)

var _current_status := SkillNodeStatus.UNREVEALED


func _ready() -> void:
	_validate_skill_node_resource()
	_register_with_game_manager()
	_draw_lines()
	
	
func _draw_lines() -> void:
	for skill_node in _get_child_skill_nodes():			
		var line := Line2D.new()

		# Vector2.ZERO is (0,0), which is exactly the center of the parent
		line.add_point(Vector2.ZERO) 
		line.add_point(skill_node.position)
		line.z_index = -1

		line.default_color = Color(1.0, 1.0, 1.0, 1.0)
		line.self_modulate = COLOR_MODULATOR_UNAVAILABLE
		line.width = 2.0

		add_child(line)


func get_cost() -> int:
	return skill_node_resource.skill_cost
	
	
func get_modifier_value() -> float:
	return skill_node_resource.modifier_value
	
func update_from_game_data() -> void:
	_update_node_appearance_from_game_data()
	_update_lines_appearance_from_game_data()


func _update_node_appearance_from_game_data() -> void:
	pass
	
	
func _update_lines_appearance_from_game_data() -> void:
	pass
	
	
func _register_with_game_manager() -> void:
	GameManager.register_skill_node(self)
	

func _get_child_skill_nodes() -> Array[SkillTreeNode]:
	var arr: Array[SkillTreeNode] = []
	for node in find_children("*", "SkillTreeNode", true, false):
		var skill_node := node as SkillTreeNode
		if skill_node: 
			arr.append(skill_node)
		
	return arr
	
func _get_child_lines() -> Array[Line2D]:
	var arr: Array[Line2D] = []
	for node in find_children("*", "Line2D", true, false):
		var line := node as Line2D
		if line: 
			arr.append(line)
	
	return arr
	
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		skill_tree_node_clicked.emit(self)
		

func _validate_skill_node_resource() -> void:
	assert(skill_node_resource != null)
	assert(skill_node_resource.skill_name != null and skill_node_resource.skill_name != "")
