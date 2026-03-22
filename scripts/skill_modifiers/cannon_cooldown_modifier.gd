class_name CannonCooldownModifier extends ModifierBase

func get_cooldown(purchased_nodes: Array[SkillTreeNode]) -> float:
	var cc_nodes := purchased_nodes.filter(func(node: SkillTreeNode) -> bool:
		return node.skill_node_resource.affected_stat == SkillNodeResource.AffectedStat.CANNON_COOLDOWN
	)	
	
	return get_cached_value(cc_nodes)
