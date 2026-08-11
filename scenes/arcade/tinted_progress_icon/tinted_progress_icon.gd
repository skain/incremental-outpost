class_name TintedProgressIcon extends TextureProgressBar

signal countdown_complete

var _time_remaining: float = 0.0


func _process(delta: float) -> void:
	if _time_remaining > 0.0:
		_time_remaining -= delta
		# If counting down to empty:
		value = _time_remaining
		
		if _time_remaining <= 0.0:
			_time_remaining = 0.0
			_on_countdown_complete()


func start_countdown(duration: float) -> void:
	max_value = duration
	_time_remaining = duration
	value = duration
	set_process(true)


func _on_countdown_complete() -> void:
	set_process(false)
	countdown_complete.emit()
