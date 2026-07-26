class_name SkillModifier

var _affected_stat : SkillTreeNode.AffectedStat
var _refresh_requested := true
var _cached_value := 0.0

func _init(stat: SkillTreeNode.AffectedStat) -> void:
	_affected_stat = stat


func get_value(purchased_nodes: Array[SkillNodeData]) -> float:
	var stat_nodes := find_nodes_by_affected_stat(_affected_stat, purchased_nodes)
	return get_cached_value(stat_nodes)



func _refresh_cache(owned_nodes: Array[SkillNodeData]) -> void:
	_cached_value = 0.0
	for node: SkillNodeData in owned_nodes:
		if node.modifier_type == SkillTreeNode.ModifierType.ADD:
			_cached_value += node.modifier_value
		elif node.modifier_type == SkillTreeNode.ModifierType.MULTIPLY:
			if _cached_value == 0.0:
				_cached_value = 1
			_cached_value *= node.modifier_value


func get_cached_value(owned_nodes: Array[SkillNodeData]) -> float:
	if _refresh_requested:
		_refresh_cache(owned_nodes)
		_refresh_requested = false
	return _cached_value
	


func request_refresh() -> void:
	_refresh_requested = true
	
	
func find_nodes_by_affected_stat(affected_stat: SkillTreeNode.AffectedStat, nodes_list: Array[SkillNodeData]) -> Array[SkillNodeData]:
	var found_nodes := nodes_list.filter(func(node: SkillNodeData) -> bool:
		return node.affected_stat == affected_stat
	)
	
	return found_nodes
