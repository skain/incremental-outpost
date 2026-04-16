class_name ShieldTimeoutModifier extends ModifierBase

func get_value(purchased_nodes: Array[SkillTreeNode]) -> float:
	var stat_nodes := find_nodes_by_affected_stat(SkillTreeNode.AffectedStat.SHIELD_TIMEOUT, purchased_nodes)
	return max(get_cached_value(stat_nodes), 1.0)
