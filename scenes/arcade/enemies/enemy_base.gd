@abstract
class_name Enemy
extends Area2D


@abstract func take_damage() -> void


@abstract func spawn(level: int) -> void

func _calc_cur_points(enemy_level: int, base_points: int) -> int:
	var cur_mult : float = max(SkillsManager.get_as_float(Enums.SkillTypes.POINTS_MULTIPLIER), 1.0)
	var points := int(round(enemy_level * cur_mult * base_points))
	return points
