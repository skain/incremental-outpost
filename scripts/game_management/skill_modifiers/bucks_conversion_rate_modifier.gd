class_name BucksConversionRateModifier extends ModifierBase

func get_value(purchased_nodes: Array[SkillNodeData]) -> float:
	var stat_nodes := find_nodes_by_affected_stat(SkillTreeNode.AffectedStat.BUCKS_CONVERSION_RATE, purchased_nodes)
	return max(get_cached_value(stat_nodes), 1.0)
