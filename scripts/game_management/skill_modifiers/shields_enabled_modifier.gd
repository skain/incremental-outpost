class_name ShieldsEnabledModifier extends ModifierBase

func get_value(purchased_nodes: Array[SkillTreeNode]) -> bool:
	var se_nodes := find_nodes_by_affected_stat(SkillNodeResource.AffectedStat.SHIELDS_ENABLED, purchased_nodes)
	var val := get_cached_value(se_nodes)
	return bool(val)
