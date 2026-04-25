class_name SkillNodeData extends RefCounted

var skill_name: String
var skill_desc: String
var skill_cost: int
var affected_stat: SkillTreeNode.AffectedStat
var modifier_type: SkillTreeNode.ModifierType
var modifier_value: float

func _init(node: SkillTreeNode) -> void:
	skill_name = node.skill_name
	skill_desc = node.skill_desc
	skill_cost = node.skill_cost
	affected_stat = node.affected_stat
	modifier_type = node.modifier_type
	modifier_value = node.modifier_value
