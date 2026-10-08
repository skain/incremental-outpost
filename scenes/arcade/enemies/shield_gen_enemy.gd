class_name ShieldGenEnemy extends Enemy

const BASE_POINTS := 100
const HIT_AUDIO := preload("res://assets/sounds/8-bit Sound Library/Explosion_00.wav")
const SPAWN_AUDIO := preload("res://assets/sounds/8-bit Sound Library/Hit_01.wav")

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var debug_label: Label = %DebugLabel

var enemy_level := 1
var cur_points := BASE_POINTS
var _is_dying := false


func take_damage() -> void:
	if _is_dying:
		return
	_is_dying = true
	
	await _hit_flash()
	
	SfxManager.play_sfx(HIT_AUDIO, global_position)
	
	SignalBus.enemy_hit.emit(self as Node)
	
	#best way I could figure to handle emitting the signal and queue_freeing this node
	remove_from_group("ShieldGenEnemies")
	SignalBus.shield_gen_enemies_count_changed.emit()

	queue_free()


func _update_stats() -> void:
	cur_points = _calc_cur_points(enemy_level, BASE_POINTS)
	debug_label.text = str(enemy_level)


func spawn(level: int) -> void:
	enemy_level = level
	_update_stats()
	
	#await _tween_spawn_in()
	
	SfxManager.play_sfx(SPAWN_AUDIO, global_position)
	
	SignalBus.shield_gen_enemies_count_changed.emit()


func _tween_spawn_in() -> void:
	sprite_2d.frame = 0
	var tween := create_tween()
	tween.tween_property(sprite_2d, "frame", 2, 0.3)
	await tween.finished


## --- Signal Handlers ---
func _on_area_entered(projectile: Node2D) -> void:
	if not is_instance_valid(projectile):
		return
	
	take_damage()
	
	if is_instance_valid(projectile):
		projectile.handle_hit()


func _hit_flash() -> void:
	var tween := create_tween()
	HitFlashHelper.add_hit_flash_to_tween(tween, sprite_2d)
	await tween.finished
