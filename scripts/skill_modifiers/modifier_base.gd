class_name ModifierBase extends Node

var _refresh_requested := true
var _cached_value := 0.0

func request_refresh() -> void:
	_refresh_requested = true
