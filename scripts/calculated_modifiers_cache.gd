class_name CalculatedModifiersCache extends Node

var cannon_cooldown_refresh_requested := true
var _cannon_cooldown := 0.0

func get_cannon_cooldown(nodes: Array[SkillTreeNode]) -> float:
	if cannon_cooldown_refresh_requested:
		_cannon_cooldown = 0.0
		for node in nodes:
			if node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.ADD:
				_cannon_cooldown += node.get_current_modifier_value()
			elif node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.MULTIPLY:
				_cannon_cooldown *= node.get_current_modifier_value()
	return _cannon_cooldown

func request_refresh() -> void:
	cannon_cooldown_refresh_requested = true
