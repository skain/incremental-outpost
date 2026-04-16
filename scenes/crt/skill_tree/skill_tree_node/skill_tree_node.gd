class_name SkillTreeNode extends Sprite2D

enum SkillNodeStatus {UNREVEALED, UNAFFORDABLE, AFFORDABLE, PURCHASED}
enum AffectedStat { 
	CANNON_COOLDOWN, HULL_PLATING, SHIELDS_ENABLED, SHIELD_MAX_ENERGY, SHIELD_DRAIN_RATE, SHIELD_CHARGE_RATE,
	SHIELD_TIMEOUT	
}
enum ModifierType { ADD, MULTIPLY, ENABLE }


signal skill_tree_node_clicked(node: SkillTreeNode)

#@export var skill_node_resource: SkillNodeResource

@export var skill_name: String
@export var skill_desc: String
@export var skill_cost: int
@export var affected_stat: AffectedStat
@export var modifier_type: ModifierType
@export var modifier_value: float

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
	_register_with_game_manager()
	_draw_lines()


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
		if parent.current_status != SkillNodeStatus.PURCHASED:
			current_status = SkillNodeStatus.UNREVEALED
			return
	
	if skill_cost <= GameManager.game_data.current_bucks:
		current_status = SkillNodeStatus.AFFORDABLE
	else:
		current_status = SkillNodeStatus.UNAFFORDABLE
		


func _update_node_appearance() -> void:
	self_modulate = _status_color_dict[current_status]
	
	
func _update_lines_appearance() -> void:
	var line_status := SkillNodeStatus.AFFORDABLE if current_status == SkillNodeStatus.PURCHASED else SkillNodeStatus.UNREVEALED
	for line in _get_child_lines():
		line.self_modulate = _status_color_dict[line_status]
	
	
func _register_with_game_manager() -> void:
	GameManager.register_skill_node(self)
	

func _get_child_skill_nodes() -> Array[SkillTreeNode]:
	var arr: Array[SkillTreeNode] = []
	for node in find_children("*", "SkillTreeNode", false, false):
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
	
func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		skill_tree_node_clicked.emit(self)
