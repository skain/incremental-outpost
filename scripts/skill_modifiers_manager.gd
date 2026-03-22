class_name SkillModifiersManager extends Node

var cannon_cooldown := CannonCooldownModifier.new()


func request_refresh(affected_stat: SkillNodeResource.AffectedStat) -> void:
	match affected_stat:
		SkillNodeResource.AffectedStat.CANNON_COOLDOWN:
			cannon_cooldown.request_refresh()
