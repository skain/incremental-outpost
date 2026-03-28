class_name ModifierBase extends Node

var _refresh_requested := true
var _cached_value := 0.0

func _refresh_cache(owned_nodes: Array[SkillTreeNode]) -> void:
	_cached_value = 0.0
	for node: SkillTreeNode in owned_nodes:
		if node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.ADD:
			_cached_value += node.get_modifier_value()
		elif node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.MULTIPLY:
			if _cached_value == 0.0:
				_cached_value = 1
			_cached_value *= node.get_modifier_value()


func get_cached_value(owned_nodes: Array[SkillTreeNode]) -> float:
	if _refresh_requested:
		_refresh_cache(owned_nodes)
	return _cached_value
	


func request_refresh() -> void:
	_refresh_requested = true
	
	
func find_nodes_by_affected_stat(affected_stat: SkillNodeResource.AffectedStat, nodes_list: Array[SkillTreeNode]) -> Array[SkillTreeNode]:
	var found_nodes := nodes_list.filter(func(node: SkillTreeNode) -> bool:
		return node.skill_node_resource.affected_stat == affected_stat
	)
	
	return found_nodes
