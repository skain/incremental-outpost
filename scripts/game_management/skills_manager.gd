extends Node

var base_values : Dictionary[SkillTreeNode.AffectedStat, float] = {
	SkillTreeNode.AffectedStat.CANNON_COOLDOWN: 10.0,
	SkillTreeNode.AffectedStat.BUCKS_CONVERSION_RATE: 0.1,
	SkillTreeNode.AffectedStat.SHIELD_MAX_ENERGY: 10.0,
	SkillTreeNode.AffectedStat.SHIELD_DRAIN_RATE: 30.0,
	SkillTreeNode.AffectedStat.SHIELD_CHARGE_RATE: 0.25,
	SkillTreeNode.AffectedStat.SHIELD_TIMEOUT: 5.0,
	SkillTreeNode.AffectedStat.POINTS_MULTIPLIER: 1.0
}

var modifiers := {}


func _ready() -> void:
	_add_basic_modifiers()

func request_refresh(affected_stat: SkillTreeNode.AffectedStat) -> void:
	modifiers[affected_stat].request_refresh()


func _add_basic_modifiers() -> void:
	for i : int in SkillTreeNode.AffectedStat.values():
		var base := 0.0
		if base_values.has(i):
			base = base_values[i]
		_add_basic_modifier(i, base)


func _add_basic_modifier(stat: SkillTreeNode.AffectedStat, base_val: float) -> void:
	if modifiers.has(stat):
		return
	
	modifiers[stat] = SkillModifier.new(stat, base_val)

func _get_modifier_value(stat: SkillTreeNode.AffectedStat) -> float:
	#var purchased_nodes := GameManager.get_purchased_nodes()
	var value :float = modifiers[stat].get_cached_value()
	return value


func get_modifier(stat: SkillTreeNode.AffectedStat) -> SkillModifier:
	return modifiers[stat] as SkillModifier


func get_as_bool(stat: SkillTreeNode.AffectedStat) -> bool:
	return get_modifier(stat).get_as_bool()


func get_as_int(stat: SkillTreeNode.AffectedStat) -> int:
	return get_modifier(stat).get_as_int()


func get_as_float(stat: SkillTreeNode.AffectedStat) -> float:
	return get_modifier(stat).get_as_float()
