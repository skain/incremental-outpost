extends Node

const BASE_POINTS_TO_BUCKS_RATE := 0.1
const CANNON_COOLDOWN_BASE := 10.0
const BASE_SHIELD_ENERGY_MAX := 10.0
const BASE_SHIELD_DRAIN_RATE := 30.0
const BASE_SHIELD_CHARGE_RATE := 0.25
const BASE_SHIELD_TIMEOUT := 5.0
const BASE_POINTS_MULTIPLIER := 1.0

var modifiers := {}


func _ready() -> void:
	_add_basic_modifiers()

func request_refresh(affected_stat: SkillTreeNode.AffectedStat) -> void:
	modifiers[affected_stat].request_refresh()


func _add_basic_modifiers() -> void:
	for i : int in SkillTreeNode.AffectedStat.values():
		_add_basic_modifier(i)


func _add_basic_modifier(stat: SkillTreeNode.AffectedStat) -> void:
	if modifiers.has(stat):
		return
	
	modifiers[stat] = SkillModifier.new(stat)

func _get_modifier_value(stat: SkillTreeNode.AffectedStat) -> float:
	#var purchased_nodes := GameManager.get_purchased_nodes()
	var value :float = modifiers[stat].get_cached_value()
	return value


func _calc_multiplicative(base: float, stat: SkillTreeNode.AffectedStat) -> float:
	var mod := _get_modifier_value(stat)
	if mod == 0.0:
		mod = 1.0
	var val: float = mod * base
	return val


func get_modifier(stat: SkillTreeNode.AffectedStat) -> SkillModifier:
	return modifiers[stat] as SkillModifier


func get_as_bool(stat: SkillTreeNode.AffectedStat) -> bool:
	return get_modifier(stat).get_as_bool()


func get_as_int(stat: SkillTreeNode.AffectedStat) -> int:
	return get_modifier(stat).get_as_int()


func get_as_float(stat: SkillTreeNode.AffectedStat) -> float:
	return get_modifier(stat).get_as_float()


# The rate at which points are converted to bucks at end of 
# arcade game.
func get_points_to_bucks_conversion_rate() -> float:
	var rate := _calc_multiplicative(BASE_POINTS_TO_BUCKS_RATE, SkillTreeNode.AffectedStat.BUCKS_CONVERSION_RATE)
	return rate


# How long each cannon takes to cooldown after firing
func get_cannon_cooldown() -> float:
	var cooldown := _calc_multiplicative(CANNON_COOLDOWN_BASE, SkillTreeNode.AffectedStat.CANNON_COOLDOWN)
	return cooldown


# The max amount of shield energy available
func get_shield_max_energy() -> float:
	var max_energy := _calc_multiplicative(BASE_SHIELD_ENERGY_MAX, SkillTreeNode.AffectedStat.SHIELD_MAX_ENERGY)
	return max_energy


# How quickly shields recharge when not in use
func get_shield_charge_rate() -> float:
	var cur_shield_charge_rate := _calc_multiplicative(BASE_SHIELD_CHARGE_RATE, SkillTreeNode.AffectedStat.SHIELD_CHARGE_RATE)
	return cur_shield_charge_rate


# How quickly shield energy drains when shields are in use
func get_shield_drain_rate() -> float:
	var cur_shield_drain_rate := _calc_multiplicative(BASE_SHIELD_DRAIN_RATE, SkillTreeNode.AffectedStat.SHIELD_DRAIN_RATE)
	return cur_shield_drain_rate


# When shield energy is fully depleted, a timeout must
# complete before recharging begins
func get_shield_timeout() -> float:
	var shield_timeout := _calc_multiplicative(BASE_SHIELD_TIMEOUT, SkillTreeNode.AffectedStat.SHIELD_TIMEOUT)
	return shield_timeout


#region autofire
func get_top_cannon_autofire_enabled() -> bool:
	return get_modifier(SkillTreeNode.AffectedStat.AUTOFIRE_TOP).get_as_bool()


func get_right_cannon_autofire_enabled() -> bool:
	return get_modifier(SkillTreeNode.AffectedStat.AUTOFIRE_RIGHT).get_as_bool()


func get_bottom_cannon_autofire_enabled() -> bool:
	return get_modifier(SkillTreeNode.AffectedStat.AUTOFIRE_BOTTOM).get_as_bool()


func get_left_cannon_autofire_enabled() -> bool:
	return get_modifier(SkillTreeNode.AffectedStat.AUTOFIRE_LEFT).get_as_bool()

#endregion


#region QTC
func get_qtc_cooldown() -> float:
	return 0.0


func get_qtc_chain_count() -> int:
	return 4

#endregion
