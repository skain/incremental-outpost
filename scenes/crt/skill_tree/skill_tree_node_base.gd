@abstract class_name SkillTreeNodeBase extends Sprite2D

enum SkillNodeStatus {
	UNREVEALED, UNAFFORDABLE, AFFORDABLE, PURCHASED
}

const COLOR_MODULATOR_UNREVEALED := Color(1.0, 1.0, 1.0, 0.0)
const COLOR_MODULATOR_UNAFFORDABLE := Color(0.75, 0.75, 0.75, 1.0)
const COLOR_MODULATOR_AFFORDABLE := Color(1.75, 1.75, 1.75, 1.0)
const COLOR_MODULATOR_PURCHASED := Color(0.25, 0.25, 0.25, 1.0)


@export var skill_cost: int


var current_status := SkillNodeStatus.UNREVEALED


var _status_color_dict := {
	SkillNodeStatus.UNREVEALED: COLOR_MODULATOR_UNREVEALED,
	SkillNodeStatus.UNAFFORDABLE: COLOR_MODULATOR_UNAFFORDABLE,
	SkillNodeStatus.AFFORDABLE: COLOR_MODULATOR_AFFORDABLE,
	SkillNodeStatus.PURCHASED: COLOR_MODULATOR_PURCHASED
}


func _ready() -> void:
	_draw_lines()


func update_from_game_data(recurse: bool) -> void:
	_set_status_from_game_data()
	_update_node_appearance()
	_update_lines_appearance()
	
	if recurse:
		for child_skill in _get_child_skill_nodes():
			child_skill.update_from_game_data(true)


@abstract func _set_status_from_game_data() -> void


func _update_node_appearance() -> void:
	self_modulate = _status_color_dict[current_status]
	
	
func _update_lines_appearance() -> void:
	var line_status := SkillNodeStatus.AFFORDABLE if current_status == SkillNodeStatus.PURCHASED else SkillNodeStatus.UNREVEALED
	for line in _get_child_lines():
		line.self_modulate = _status_color_dict[line_status]


func _draw_lines() -> void:
	for skill_node in _get_child_skill_nodes():			
		var line := Line2D.new()

		line.add_point(Vector2.ZERO) 
		line.add_point(skill_node.position)
		
		line.show_behind_parent = true

		line.default_color = Color(1.0, 1.0, 1.0, 1.0)
		line.self_modulate = COLOR_MODULATOR_UNREVEALED
		line.width = 2.0

		add_child(line)


func _get_child_skill_nodes() -> Array[SkillTreeNode]:
	var arr: Array[SkillTreeNode] = []
	for node in find_children("*", "SkillTreeNodeBase", false, false):
		var skill_node := node as SkillTreeNode
		if skill_node: 
			arr.append(skill_node)
	return arr


func _get_child_lines() -> Array[Line2D]:
	var arr: Array[Line2D] = []
	for node in find_children("*", "Line2D", false, false):
		var line := node as Line2D
		if line: 
			arr.append(line)
	return arr
