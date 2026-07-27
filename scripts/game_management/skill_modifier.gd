class_name SkillModifier

var _affected_stat : Enums.SkillTypes
var _refresh_requested := true
var _base_value : float
var _cached_value := 0.0

func _init(stat: Enums.SkillTypes, base_val := 0.0) -> void:
	_affected_stat = stat
	_base_value = base_val


func _refresh_cache(purchased_nodes: Array[SkillNodeData]) -> void:
	var relevant_nodes := find_nodes_by_affected_stat(_affected_stat, purchased_nodes)
	_cached_value = _base_value
	for node: SkillNodeData in relevant_nodes:
		if node.modifier_type == Enums.SkillModifierTypes.ADD:
			_cached_value += node.modifier_value
		elif node.modifier_type == Enums.SkillModifierTypes.MULTIPLY:
			_cached_value *= node.modifier_value


func get_cached_value() -> float:
	if _refresh_requested:
		var purchased_nodes := GameManager.get_purchased_nodes()
		_refresh_cache(purchased_nodes)
		_refresh_requested = false
	return _cached_value


func get_as_float() -> float:
	return get_cached_value()


func get_as_bool() -> bool:
	return bool(get_cached_value())


func get_as_int() -> int:
	return int(get_cached_value())


func request_refresh() -> void:
	_refresh_requested = true
	
	
func find_nodes_by_affected_stat(affected_stat: Enums.SkillTypes, nodes_list: Array[SkillNodeData]) -> Array[SkillNodeData]:
	var found_nodes := nodes_list.filter(func(node: SkillNodeData) -> bool:
		return node.affected_stat == affected_stat
	)
	
	return found_nodes
