class_name CannonCooldownModifier extends ModifierBase

func get_value(purchased_nodes: Array[SkillTreeNode]) -> float:
	var stat_nodes := find_nodes_by_affected_stat(SkillNodeResource.AffectedStat.CANNON_COOLDOWN, purchased_nodes)
	
	return get_cached_value(stat_nodes)
