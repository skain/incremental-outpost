class_name SkillsManager extends Node

const BASE_POINTS_TO_BUCKS_RATE := 0.1
const CANNON_COOLDOWN_BASE := 10.0
const BASE_SHIELD_ENERGY_MAX := 10.0
const BASE_SHIELD_DRAIN_RATE := 30.0
const BASE_SHIELD_CHARGE_RATE := 0.25
const BASE_SHIELD_TIMEOUT := 5.0

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
		BucksConversionRateModifier.new()
}


func request_refresh(affected_stat: SkillTreeNode.AffectedStat) -> void:
	modifiers[affected_stat].request_refresh()


func _get_modifier_value(stat: SkillTreeNode.AffectedStat) -> float:
	var purchased_nodes := GameManager.get_purchased_nodes()
	return modifiers[stat].get_value(purchased_nodes)


func get_points_to_bucks_conversion_rate() -> float:
	var mod := _get_modifier_value(SkillTreeNode.AffectedStat.BUCKS_CONVERSION_RATE)
	var rate := BASE_POINTS_TO_BUCKS_RATE * mod
	return rate


func get_shields_enabled() -> bool:
	return bool(_get_modifier_value(SkillTreeNode.AffectedStat.SHIELDS_ENABLED))


func get_cannon_cooldown() -> float:
	var mod := _get_modifier_value(SkillTreeNode.AffectedStat.CANNON_COOLDOWN)
	if mod == 0.0:
		mod = 1.0
	var cooldown: float = mod * CANNON_COOLDOWN_BASE
	return cooldown


func get_shield_max_energy() -> float:
	var max_energy_mod := _get_modifier_value(SkillTreeNode.AffectedStat.SHIELD_MAX_ENERGY)
	var cur_shield_energy_max := max_energy_mod * BASE_SHIELD_ENERGY_MAX
	return cur_shield_energy_max


func get_shield_charge_rate() -> float:
	var charge_rate_mod := _get_modifier_value(SkillTreeNode.AffectedStat.SHIELD_CHARGE_RATE)
	var cur_shield_charge_rate := charge_rate_mod * BASE_SHIELD_CHARGE_RATE
	return cur_shield_charge_rate


func get_shield_drain_rate() -> float:
	var drain_rate_mod := _get_modifier_value(SkillTreeNode.AffectedStat.SHIELD_DRAIN_RATE)
	var cur_shield_drain_rate := drain_rate_mod * BASE_SHIELD_DRAIN_RATE
	return cur_shield_drain_rate


func get_shield_timeout() -> float:
	var timeout_mod := _get_modifier_value(SkillTreeNode.AffectedStat.SHIELD_TIMEOUT)
	var shield_timeout := timeout_mod * BASE_SHIELD_TIMEOUT
	return shield_timeout


func get_hull_plating() -> int:
	var plating := int(_get_modifier_value(SkillTreeNode.AffectedStat.HULL_PLATING))
	return plating
