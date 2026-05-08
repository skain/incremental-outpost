class_name SkillNodeInfoContainer extends CenterContainer

signal buy_button_pressed(node: SkillTreeNodeBase)

@onready var skill_name_label: Label = %SkillNameLabel
@onready var skill_description_label: Label = %SkillDescriptionLabel
@onready var skill_cost_label: Label = %SkillCostLabel
@onready var buy_button: Button = %BuyButton
@onready var skill_icon_texture_rect: TextureRect = %SkillIconTextureRect
@onready var skill_buttons_container: HBoxContainer = %SkillButtonsContainer
@onready var story_buttons_container: HBoxContainer = %StoryButtonsContainer
@onready var cost_container: HBoxContainer = %CostContainer

var displayed_node: SkillTreeNodeBase

func load_node_info(node: SkillTreeNodeBase) -> void:
	displayed_node = node
	skill_icon_texture_rect.texture = node.texture
	buy_button.disabled = not GameManager.is_affordable_bucks(node.skill_cost)
	
	var story_node := node as StorySkillTreeNode
	if story_node:
		skill_name_label.text = story_node.story_subject
		skill_description_label.text = story_node.story_text
		cost_container.hide()
		skill_buttons_container.hide()
		story_buttons_container.show()
	else:
		skill_name_label.text = node.skill_name
		skill_description_label.text = node.skill_desc
		skill_cost_label.text = str(node.skill_cost)
		cost_container.show()
		skill_buttons_container.show()
		story_buttons_container.hide()
		


func _clear_info_and_hide() -> void:
	displayed_node = null
	visible = false

func _on_buy_button_pressed() -> void:
	assert(displayed_node)
	if displayed_node.current_status != SkillTreeNodeBase.SkillNodeStatus.PURCHASED:
		buy_button_pressed.emit(displayed_node)
	else:
		_clear_info_and_hide()


func _on_close_button_pressed() -> void:
	_clear_info_and_hide()
