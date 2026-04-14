class_name ModifierBase extends Node

var _refresh_requested := true
var _cached_value := 0.0

func _refresh_cache(owned_nodes: Array[SkillTreeNode]) -> void:
	_cached_value = 0.0
	for node: SkillTreeNode in owned_nodes:
		if node.modifier_type == SkillTreeNode.ModifierType.ADD:
			_cached_value += node.modifier_value
		elif node.modifier_type == SkillTreeNode.ModifierType.MULTIPLY:
			if _cached_value == 0.0:
				_cached_value = 1
			_cached_value *= node.modifier_value


func get_cached_value(owned_nodes: Array[SkillTreeNode]) -> float:
	if _refresh_requested:
		_refresh_cache(owned_nodes)
		_refresh_requested = false
	return _cached_value
	


func request_refresh() -> void:
	_refresh_requested = true
	
	
func find_nodes_by_affected_stat(affected_stat: SkillTreeNode.AffectedStat, nodes_list: Array[SkillTreeNode]) -> Array[SkillTreeNode]:
	var found_nodes := nodes_list.filter(func(node: SkillTreeNode) -> bool:
		return node.affected_stat == affected_stat
	)
	
	return found_nodes
