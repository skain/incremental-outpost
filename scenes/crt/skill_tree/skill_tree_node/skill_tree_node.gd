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






func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		skill_tree_node_clicked.emit(self)
