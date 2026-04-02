class_name CannonCooldownModifier extends ModifierBase

func get_cooldown(purchased_nodes: Array[SkillTreeNode]) -> float:
	var cc_nodes := find_nodes_by_affected_stat(SkillNodeResource.AffectedStat.CANNON_COOLDOWN, purchased_nodes)
	
	return get_cached_value(cc_nodes)
