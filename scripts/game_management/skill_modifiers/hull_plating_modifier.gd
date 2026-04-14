class_name HullPlatingModifier extends ModifierBase

func get_value(purchased_nodes: Array[SkillTreeNode]) -> int:
	var stat_nodes := find_nodes_by_affected_stat(SkillTreeNode.AffectedStat.HULL_PLATING, purchased_nodes)
	
	return int(get_cached_value(stat_nodes))
