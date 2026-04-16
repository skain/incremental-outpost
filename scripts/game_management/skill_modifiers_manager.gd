class_name SkillModifiersManager extends Node

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
		ShieldTimeoutModifier.new()
}


func request_refresh(affected_stat: SkillTreeNode.AffectedStat) -> void:
	modifiers[affected_stat].request_refresh()


func get_modifier_value(stat: SkillTreeNode.AffectedStat, purchased_nodes: Array[SkillTreeNode]) -> float:
	return modifiers[stat].get_value(purchased_nodes)
