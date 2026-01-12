extends Area2D
class_name Enemy

@export var hit_timeout_secs: int = 5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var revive_timer: Timer = $ReviveTimer

func _enable() -> void:
	print('enabled')
	visible = true
	collision_shape_2d.set_deferred("disabled", false)
	
func _disable() -> void:
	print('disabled')
	visible = false
	collision_shape_2d.set_deferred("disabled", true)
	revive_timer.start(hit_timeout_secs)
	
func _on_revive_timer_timeout() -> void:
	_enable()

func _on_area_entered(area: Area2D) -> void:
	print('hit')
	_disable()
	area.queue_free()
