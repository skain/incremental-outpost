extends Node

# This dict is a little weird but seemed like the least code-heavy
# way to define base values for different stats. If the stat is 
# not included in this dict then its base is set to 0.0
var base_values : Dictionary[Enums.SkillTypes, float] = {
	Enums.SkillTypes.CANNON_COOLDOWN: 10.0,
	Enums.SkillTypes.BUCKS_CONVERSION_RATE: 0.1,
	Enums.SkillTypes.SHIELD_MAX_ENERGY: 10.0,
	Enums.SkillTypes.SHIELD_DRAIN_RATE: 30.0,
	Enums.SkillTypes.SHIELD_CHARGE_RATE: 0.25,
	Enums.SkillTypes.SHIELD_TIMEOUT: 5.0,
	Enums.SkillTypes.POINTS_MULTIPLIER: 1.0,
	Enums.SkillTypes.QTC_CHARGE_TIME: 10.0,
	Enums.SkillTypes.QTC_ORBIT_SPEED: 1.0
}

var modifiers := {}


func _ready() -> void:
	_add_basic_modifiers()

func request_refresh(affected_stat: Enums.SkillTypes) -> void:
	modifiers[affected_stat].request_refresh()


func _add_basic_modifiers() -> void:
	for stat : int in Enums.SkillTypes.values():
		if modifiers.has(stat):
			return
		
		var base_val := 0.0
		if base_values.has(stat):
			base_val = base_values[stat]
		
		modifiers[stat] = SkillModifier.new(stat, base_val)

func _get_modifier_value(stat: Enums.SkillTypes) -> float:
	var value :float = modifiers[stat].get_cached_value()
	return value


func get_modifier(stat: Enums.SkillTypes) -> SkillModifier:
	return modifiers[stat] as SkillModifier


func get_as_bool(stat: Enums.SkillTypes) -> bool:
	return get_modifier(stat).get_as_bool()


func get_as_int(stat: Enums.SkillTypes) -> int:
	return get_modifier(stat).get_as_int()


func get_as_float(stat: Enums.SkillTypes) -> float:
	return get_modifier(stat).get_as_float()
