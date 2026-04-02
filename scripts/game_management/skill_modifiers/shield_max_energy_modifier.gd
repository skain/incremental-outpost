class_name ShieldMaxEnergyModifier extends ModifierBase


func get_shield_max_energy(purchased_nodes: Array[SkillTreeNode]) -> int:
	var sme_nodes := find_nodes_by_affected_stat(SkillNodeResource.AffectedStat.SHIELD_MAX_ENERGY, purchased_nodes)
	
	return int(get_cached_value(sme_nodes))
