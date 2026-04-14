class_name ShieldMaxEnergyModifier extends ModifierBase


func get_value(purchased_nodes: Array[SkillTreeNode]) -> float:
	var stat_nodes := find_nodes_by_affected_stat(SkillTreeNode.AffectedStat.SHIELD_MAX_ENERGY, purchased_nodes)
	
	return max(get_cached_value(stat_nodes), 1)
