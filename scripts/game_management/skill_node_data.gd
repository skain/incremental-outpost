class_name SkillNodeData extends RefCounted

var skill_name: String
var skill_desc: String
var skill_cost: int
var affected_stat: SkillTreeNode.AffectedStat
var modifier_type: SkillTreeNode.ModifierType
var modifier_value: float

func _init(node: SkillTreeNodeBase) -> void:
	if node is SkillTreeNode:
		_load_from_skill_tree_node(node)
	elif node is StorySkillTreeNode:
		_load_from_story_skill_tree_node(node)
	else:
		assert(false)


func _load_from_skill_tree_node(node: SkillTreeNode) -> void:
	skill_name = node.skill_name
	skill_desc = node.skill_desc
	skill_cost = node.skill_cost
	affected_stat = node.affected_stat
	modifier_type = node.modifier_type
	modifier_value = node.modifier_value


func _load_from_story_skill_tree_node(node: StorySkillTreeNode) -> void:
	skill_name = node.story_subject
	skill_desc = node.story_text
	skill_cost = 0
