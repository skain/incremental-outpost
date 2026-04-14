class_name ShieldsEnabledModifier extends ModifierBase

func get_value(purchased_nodes: Array[SkillTreeNode]) -> bool:
	var stat_nodes := find_nodes_by_affected_stat(SkillTreeNode.AffectedStat.SHIELDS_ENABLED, purchased_nodes)
	var val := get_cached_value(stat_nodes)
	return bool(val)
