class_name SkillTreeNode extends Sprite2D

enum SkillNodeStatus {UNREVEALED, UNAFFORDABLE, AFFORDABLE, PURCHASED}

signal skill_tree_node_clicked(node: SkillTreeNode)

@export var skill_node_resource: SkillNodeResource

const COLOR_MODULATOR_UNREVEALED := Color(1.0, 1.0, 1.0, 0.0)
const COLOR_MODULATOR_UNAFFORDABLE := Color(0.75, 0.75, 0.75, 1.0)
const COLOR_MODULATOR_AFFORDABLE := Color(1.75, 1.75, 1.75, 1.0)
const COLOR_MODULATOR_PURCHASED := Color(0.25, 0.25, 0.25, 1.0)

var current_status := SkillNodeStatus.UNREVEALED

var _status_color_dict := {
	SkillNodeStatus.UNREVEALED: COLOR_MODULATOR_UNREVEALED,
	SkillNodeStatus.UNAFFORDABLE: COLOR_MODULATOR_UNAFFORDABLE,
	SkillNodeStatus.AFFORDABLE: COLOR_MODULATOR_AFFORDABLE,
	SkillNodeStatus.PURCHASED: COLOR_MODULATOR_PURCHASED
}


func _ready() -> void:
	_validate_skill_node_resource()
	_register_with_game_manager()
	_load_data_from_resource()
	_draw_lines()


func _load_data_from_resource() -> void:
	if skill_node_resource.skill_icon:
		texture = skill_node_resource.skill_icon


func _draw_lines() -> void:
	for skill_node in _get_child_skill_nodes():			
		var line := Line2D.new()

		# Vector2.ZERO is (0,0), which is exactly the center of the parent
		line.add_point(Vector2.ZERO) 
		line.add_point(skill_node.position)
		line.z_index = -1

		line.default_color = Color(1.0, 1.0, 1.0, 1.0)
		line.self_modulate = COLOR_MODULATOR_UNREVEALED
		line.width = 2.0

		add_child(line)


func get_cost() -> int:
	return skill_node_resource.skill_cost
	
	
func get_modifier_value() -> float:
	return skill_node_resource.modifier_value
	
	
func update_from_game_data(recurse: bool) -> void:
	_set_status_from_game_data()
	_update_node_appearance()
	_update_lines_appearance()
	
	if recurse:
		for child_skill in _get_child_skill_nodes():
			child_skill.update_from_game_data(true)


func _set_status_from_game_data() -> void:
	if GameManager.is_node_purchased(self):
		current_status = SkillNodeStatus.PURCHASED
		return
		
	var parent := get_parent() as SkillTreeNode
	if parent:
		#this isn't the root node
		if parent.current_status == SkillNodeStatus.UNREVEALED:
			current_status = SkillNodeStatus.UNREVEALED
			return
	
	if get_cost() <= GameManager.game_data.current_bucks:
		current_status = SkillNodeStatus.AFFORDABLE
	else:
		current_status = SkillNodeStatus.UNAFFORDABLE
		


func _update_node_appearance() -> void:
	self_modulate = _status_color_dict[current_status]
	
	
func _update_lines_appearance() -> void:
	for line in _get_child_lines():
		line.self_modulate = _status_color_dict[current_status]
	
	
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
