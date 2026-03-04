class_name SkillNodeInfoContainer extends CenterContainer

signal buy_button_pressed(node: SkillTreeNode)
signal close_button_pressed

@onready var skill_name_label: Label = %SkillNameLabel
@onready var skill_description_label: Label = %SkillDescriptionLabel
@onready var skill_cost_label: Label = %SkillCostLabel

var displayed_node: SkillTreeNode

func load_node_info(node: SkillTreeNode) -> void:
	displayed_node = node
	var res := node.skill_node_resource
	skill_name_label.text = res.skill_name
	skill_description_label.text = res.skill_desc
	skill_cost_label.text = str(res.skill_cost)


func _on_buy_button_pressed() -> void:
	assert(displayed_node)
	buy_button_pressed.emit(displayed_node)


func _on_close_button_pressed() -> void:
	close_button_pressed.emit()
