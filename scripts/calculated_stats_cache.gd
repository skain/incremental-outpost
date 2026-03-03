class_name CalculatedStatsCache extends Node

var cannon_cooldown_refresh_requested := true
var _cannon_cooldown := -1.0

func get_cannon_cooldown() -> float:
	return _cannon_cooldown
