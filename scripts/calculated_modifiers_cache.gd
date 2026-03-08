class_name CalculatedModifiersCache extends Node

var cannon_cooldown_refresh_requested := true
var _cannon_cooldown := 0.0

func get_cannon_cooldown(nodes: Array[SkillTreeNode]) -> float:
	if cannon_cooldown_refresh_requested:
		_cannon_cooldown = 0.0
		for node in nodes:
			#print("calculating upgrade for node: " + node.name)
			if node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.ADD:
				#print("Adding")
				_cannon_cooldown += node.get_modifier_value()
			elif node.skill_node_resource.modifier_type == SkillNodeResource.ModifierType.MULTIPLY:
				#print("Multiplying by " + str(node.get_modifier_value()))
				if _cannon_cooldown == 0.0:
					_cannon_cooldown = 1
				_cannon_cooldown *= node.get_modifier_value()
				#print("New cooldown: " + str(_cannon_cooldown))
	return _cannon_cooldown

func request_refresh() -> void:
	#print("refresh requested")
	cannon_cooldown_refresh_requested = true
