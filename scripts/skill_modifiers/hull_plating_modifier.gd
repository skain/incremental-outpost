class_name HullPlatingModifier extends ModifierBase

func get_hull_plating_amount(purchased_nodes: Array[SkillTreeNode]) -> int:
	var hp_nodes := purchased_nodes.filter(func(node: SkillTreeNode) -> bool:
		return node.skill_node_resource.affected_stat == SkillNodeResource.AffectedStat.HULL_PLATING
	)
	
	return int(get_cached_value(hp_nodes))
