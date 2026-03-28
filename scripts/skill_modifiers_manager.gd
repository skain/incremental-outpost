class_name SkillModifiersManager extends Node

var cannon_cooldown := CannonCooldownModifier.new()
var hull_plating := HullPlatingModifier.new()
var shields_enabled := ShieldsEnabledModifier.new()


func request_refresh(affected_stat: SkillNodeResource.AffectedStat) -> void:
	match affected_stat:
		SkillNodeResource.AffectedStat.CANNON_COOLDOWN:
			cannon_cooldown.request_refresh()
		SkillNodeResource.AffectedStat.HULL_PLATING:
			hull_plating.request_refresh()
		SkillNodeResource.AffectedStat.SHIELDS_ENABLED:
			shields_enabled.request_refresh()
