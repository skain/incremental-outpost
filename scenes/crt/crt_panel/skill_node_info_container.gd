class_name SkillNodeInfoContainer extends CenterContainer

@onready var skill_name_label: Label = %SkillNameLabel
@onready var skill_description_label: Label = %SkillDescriptionLabel
@onready var skill_cost_label: Label = %SkillCostLabel

func load_node_info(node: SkillTreeNode) -> void:
	var res := node.skill_node_resource
	skill_name_label.text = res.skill_name
	skill_description_label.text = res.skill_desc
	skill_cost_label.text = str(res.skill_cost)
