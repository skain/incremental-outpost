class_name SkillTreeNode extends SkillTreeNodeBase

@export var skill_name: String
@export var skill_desc: String
@export var affected_stat: Enums.SkillTypes
@export var modifier_type: Enums.SkillModifierTypes
@export var modifier_value: float


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		skill_tree_node_clicked.emit(self)
