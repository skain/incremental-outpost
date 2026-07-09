class_name AutoshieldsModifier extends ModifierBase

var affected_stat : SkillTreeNode.AffectedStat

func _init(outpost_arm: Enums.OutpostArms) -> void:
	match outpost_arm:
		Enums.OutpostArms.TOP:
			affected_stat = SkillTreeNode.AffectedStat.AUTOSHIELD_TOP
		Enums.OutpostArms.RIGHT:
			affected_stat = SkillTreeNode.AffectedStat.AUTOSHIELD_RIGHT
		Enums.OutpostArms.BOTTOM:
			affected_stat = SkillTreeNode.AffectedStat.AUTOSHIELD_BOTTOM
		Enums.OutpostArms.LEFT:
			affected_stat = SkillTreeNode.AffectedStat.AUTOSHIELD_LEFT


func get_value(purchased_nodes: Array[SkillNodeData]) -> bool:	
	var stat_nodes := find_nodes_by_affected_stat(affected_stat, purchased_nodes)
	var val := get_cached_value(stat_nodes)
	return bool(val)
