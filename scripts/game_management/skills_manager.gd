class_name SkillsManager extends Node

const BASE_POINTS_TO_BUCKS_RATE := 0.1
const CANNON_COOLDOWN_BASE := 10.0
const BASE_SHIELD_ENERGY_MAX := 10.0
const BASE_SHIELD_DRAIN_RATE := 30.0
const BASE_SHIELD_CHARGE_RATE := 0.25
const BASE_SHIELD_TIMEOUT := 5.0
const BASE_POINTS_MULTIPLIER := 1.0

var modifiers := {
	SkillTreeNode.AffectedStat.CANNON_COOLDOWN:  CannonCooldownModifier.new(),
	SkillTreeNode.AffectedStat.HULL_PLATING:
		HullPlatingModifier.new(),
	SkillTreeNode.AffectedStat.SHIELDS_ENABLED:
		ShieldsEnabledModifier.new(),
	SkillTreeNode.AffectedStat.SHIELD_MAX_ENERGY:
		ShieldMaxEnergyModifier.new(),
	SkillTreeNode.AffectedStat.SHIELD_DRAIN_RATE:
		ShieldDrainRateModifier.new(),
	SkillTreeNode.AffectedStat.SHIELD_CHARGE_RATE:
		ShieldChargeRateModifier.new(),
	SkillTreeNode.AffectedStat.SHIELD_TIMEOUT:
		ShieldTimeoutModifier.new(),
	SkillTreeNode.AffectedStat.BUCKS_CONVERSION_RATE:
		BucksConversionRateModifier.new(),
	SkillTreeNode.AffectedStat.POINTS_MULTIPLIER:
		PointsMultiplierModifier.new(),
	SkillTreeNode.AffectedStat.NUM_SMART_BOMBS:
		SmartBombsModifier.new()
}


func request_refresh(affected_stat: SkillTreeNode.AffectedStat) -> void:
	modifiers[affected_stat].request_refresh()


func _get_modifier_value(stat: SkillTreeNode.AffectedStat) -> float:
	var purchased_nodes := GameManager.get_purchased_nodes()
	var value :float = modifiers[stat].get_value(purchased_nodes)
	return value


func _calc_multiplicative(base: float, stat: SkillTreeNode.AffectedStat) -> float:
	var mod := _get_modifier_value(stat)
	if mod == 0.0:
		mod = 1.0
	var val: float = mod * base
	return val


# The rate at which points are converted to bucks at end of 
# arcade game.
func get_points_to_bucks_conversion_rate() -> float:
	var rate := _calc_multiplicative(BASE_POINTS_TO_BUCKS_RATE, SkillTreeNode.AffectedStat.BUCKS_CONVERSION_RATE)
	return rate


# Controls whether shields are available for use.
func get_shields_enabled() -> bool:
	return bool(_get_modifier_value(SkillTreeNode.AffectedStat.SHIELDS_ENABLED))


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


# Each level of hull plating absorbs one core hit
func get_hull_plating() -> int:
	var plating := int(_get_modifier_value(SkillTreeNode.AffectedStat.HULL_PLATING))
	return plating


# Applied when calculating points to award for destroying an enemy
func get_points_multiplier() -> float:
	var pm := _get_modifier_value(SkillTreeNode.AffectedStat.POINTS_MULTIPLIER)
	return pm


func get_num_smart_bombs() -> int:
	var smart_bombs := int(_get_modifier_value(SkillTreeNode.AffectedStat.NUM_SMART_BOMBS))
	return smart_bombs
