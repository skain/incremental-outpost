class_name CannonCooldownModifier extends ModifierBase

func get_cooldown(purchased_nodes: Array[SkillTreeNode]) -> float:
	var cc_nodes := purchased_nodes.filter(func(node: SkillTreeNode) -> bool:
		return node.skill_node_resource.affected_stat == SkillNodeResource.AffectedStat.CANNON_COOLDOWN
	)
	
	if _refresh_requested:
		_cached_value = 0.0
		for node: SkillTreeNode in cc_nodes:
			if node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.ADD:
				_cached_value += node.get_modifier_value()
			elif node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.MULTIPLY:
				if _cached_value == 0.0:
					_cached_value = 1
				_cached_value *= node.get_modifier_value()
	return _cached_value
