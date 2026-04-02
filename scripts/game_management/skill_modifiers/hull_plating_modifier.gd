class_name HullPlatingModifier extends ModifierBase

func get_hull_plating_amount(purchased_nodes: Array[SkillTreeNode]) -> int:
	var hp_nodes := find_nodes_by_affected_stat(SkillNodeResource.AffectedStat.HULL_PLATING, purchased_nodes)
	
	return int(get_cached_value(hp_nodes))
