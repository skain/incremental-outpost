extends Area2D
class_name Enemy

signal enemy_hit(enemy:Enemy)

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var revive_timer: Timer = $ReviveTimer

var enemy_level := 1
var disable_decay_factor := .9

func _enable() -> void:
	#print('enabled')
	visible = true
	collision_shape_2d.set_deferred("disabled", false)
	
func _disable() -> void:
	#print('disabled')
	visible = false
	collision_shape_2d.set_deferred("disabled", true)
	var hit_timeout_secs :float =  5 * (disable_decay_factor ** (enemy_level - 1))
	revive_timer.start(hit_timeout_secs)
	
func _on_revive_timer_timeout() -> void:
	_enable()

func _on_area_entered(area: Area2D) -> void:
	#print('hit')
	_disable()
	enemy_hit.emit(self)
	area.queue_free()
