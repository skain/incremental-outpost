class_name ShieldDrainRateModifier extends ModifierBase

func get_shield_drain_rate(purchased_nodes: Array[SkillTreeNode]) -> float:
	var sme_nodes := find_nodes_by_affected_stat(SkillNodeResource.AffectedStat.SHIELD_DRAIN_RATE, purchased_nodes)
	return max(get_cached_value(sme_nodes), 1.0)
