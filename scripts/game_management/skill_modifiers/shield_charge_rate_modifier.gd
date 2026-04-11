class_name ShieldChargeRateModifier extends ModifierBase

func get_value(purchased_nodes: Array[SkillTreeNode]) -> float:
	var sme_nodes := find_nodes_by_affected_stat(SkillNodeResource.AffectedStat.SHIELD_CHARGE_RATE, purchased_nodes)
	return max(get_cached_value(sme_nodes), 1.0)
