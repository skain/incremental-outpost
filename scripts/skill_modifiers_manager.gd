class_name SkillModifiersManager extends Node

var cannon_cooldown_refresh_requested := true
var _cannon_cooldown := 0.0

func get_cannon_cooldown(purchased_nodes: Array[SkillTreeNode]) -> float:
	var cc_nodes := purchased_nodes.filter(func(node: SkillTreeNode) -> bool:
		return node.skill_node_resource.affected_stat == SkillNodeResource.AffectedStat.CANNON_COOLDOWN
	)
	
	if cannon_cooldown_refresh_requested:
		_cannon_cooldown = 0.0
		for node: SkillTreeNode in cc_nodes:
			if node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.ADD:
				_cannon_cooldown += node.get_modifier_value()
			elif node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.MULTIPLY:
				if _cannon_cooldown == 0.0:
					_cannon_cooldown = 1
				_cannon_cooldown *= node.get_modifier_value()
	return _cannon_cooldown


func request_refresh() -> void:
	cannon_cooldown_refresh_requested = true
