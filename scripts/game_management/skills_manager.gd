extends Node

# This dict is a little weird but seemed like the least code-heavy
# way to define base values for different stats. If the stat is 
# not included in this dict then its base is set to 0.0
var base_values : Dictionary[SkillTreeNode.AffectedStat, float] = {
	SkillTreeNode.AffectedStat.CANNON_COOLDOWN: 10.0,
	SkillTreeNode.AffectedStat.BUCKS_CONVERSION_RATE: 0.1,
	SkillTreeNode.AffectedStat.SHIELD_MAX_ENERGY: 10.0,
	SkillTreeNode.AffectedStat.SHIELD_DRAIN_RATE: 30.0,
	SkillTreeNode.AffectedStat.SHIELD_CHARGE_RATE: 0.25,
	SkillTreeNode.AffectedStat.SHIELD_TIMEOUT: 5.0,
	SkillTreeNode.AffectedStat.POINTS_MULTIPLIER: 1.0,
	SkillTreeNode.AffectedStat.QTC_CHARGE_TIME: 10.0,
	SkillTreeNode.AffectedStat.QTC_ORBIT_SPEED: 1.0
}

var modifiers := {}


func _ready() -> void:
	_add_basic_modifiers()

func request_refresh(affected_stat: SkillTreeNode.AffectedStat) -> void:
	modifiers[affected_stat].request_refresh()


func _add_basic_modifiers() -> void:
	for stat : int in SkillTreeNode.AffectedStat.values():
		if modifiers.has(stat):
			return
		
		var base_val := 0.0
		if base_values.has(stat):
			base_val = base_values[stat]
		
		modifiers[stat] = SkillModifier.new(stat, base_val)

func _get_modifier_value(stat: SkillTreeNode.AffectedStat) -> float:
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
