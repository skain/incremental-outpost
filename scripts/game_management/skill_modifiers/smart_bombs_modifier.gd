class_name SmartBombsModifier extends ModifierBase

func get_value(purchased_nodes: Array[SkillNodeData]) -> int:
	var stat_nodes := find_nodes_by_affected_stat(SkillTreeNode.AffectedStat.NUM_SMART_BOMBS, purchased_nodes)
	
	return int(get_cached_value(stat_nodes))
