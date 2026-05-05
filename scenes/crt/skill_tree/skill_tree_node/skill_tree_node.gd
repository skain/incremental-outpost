class_name SkillTreeNode extends SkillTreeNodeBase


enum AffectedStat { 
	CANNON_COOLDOWN, HULL_PLATING, SHIELDS_ENABLED, SHIELD_MAX_ENERGY, SHIELD_DRAIN_RATE, SHIELD_CHARGE_RATE, SHIELD_TIMEOUT,
	BUCKS_CONVERSION_RATE, POINTS_MULTIPLIER
}
enum ModifierType { ADD, MULTIPLY, ENABLE }


@export var skill_name: String
@export var skill_desc: String
@export var affected_stat: AffectedStat
@export var modifier_type: ModifierType
@export var modifier_value: float



func _ready() -> void:
	_register_with_game_manager()


func _register_with_game_manager() -> void:
	GameManager.register_skill_node(self)


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		skill_tree_node_clicked.emit(self)


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
