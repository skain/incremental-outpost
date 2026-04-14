class_name SkillNodeInfoContainer extends CenterContainer

signal buy_button_pressed(node: SkillTreeNode)

@onready var skill_name_label: Label = %SkillNameLabel
@onready var skill_description_label: Label = %SkillDescriptionLabel
@onready var skill_cost_label: Label = %SkillCostLabel
@onready var buy_button: Button = %BuyButton

var displayed_node: SkillTreeNode

func load_node_info(node: SkillTreeNode) -> void:
	displayed_node = node
	skill_name_label.text = node.skill_name
	skill_description_label.text = node.skill_desc
	skill_cost_label.text = str(node.skill_cost)
	buy_button.disabled = not GameManager.is_affordable_bucks(node.skill_cost)


func _clear_info_and_hide() -> void:
	displayed_node = null
	visible = false

func _on_buy_button_pressed() -> void:
	assert(displayed_node)
	buy_button_pressed.emit(displayed_node)


func _on_close_button_pressed() -> void:
	_clear_info_and_hide()
