class_name SkillModifiersManager extends Node

var modifiers := {
	SkillNodeResource.AffectedStat.CANNON_COOLDOWN:  CannonCooldownModifier.new(),
	SkillNodeResource.AffectedStat.HULL_PLATING:
		HullPlatingModifier.new(),
	SkillNodeResource.AffectedStat.SHIELDS_ENABLED:
		ShieldsEnabledModifier.new(),
	SkillNodeResource.AffectedStat.SHIELD_MAX_ENERGY:
		ShieldMaxEnergyModifier.new()	
}


func request_refresh(affected_stat: SkillNodeResource.AffectedStat) -> void:
	modifiers[affected_stat].request_refresh()
