class_name ShieldBounceModifier extends ModifierBase

var affected_stat : SkillTreeNode.AffectedStat

func _init(outpost_arm: Enums.OutpostArms) -> void:
	match outpost_arm:
		Enums.OutpostArms.TOP:
			affected_stat = SkillTreeNode.AffectedStat.TOP_SHIELD_BOUNCE
		Enums.OutpostArms.RIGHT:
			affected_stat = SkillTreeNode.AffectedStat.RIGHT_SHIELD_BOUNCE
		Enums.OutpostArms.BOTTOM:
			affected_stat = SkillTreeNode.AffectedStat.BOTTOM_SHIELD_BOUNCE
		Enums.OutpostArms.LEFT:
			affected_stat = SkillTreeNode.AffectedStat.LEFT_SHIELD_BOUNCE


func get_value(purchased_nodes: Array[SkillNodeData]) -> bool:	
	var stat_nodes := find_nodes_by_affected_stat(affected_stat, purchased_nodes)
	var val := get_cached_value(stat_nodes)
	return bool(val)
