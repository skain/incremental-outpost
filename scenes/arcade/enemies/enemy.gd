extends Area2D
class_name Enemy

signal enemy_hit(enemy: Enemy)

const PROJECTILE_SCENE = preload("res://scenes/arcade/enemy_projectile/enemy_projectile.tscn")
const BASE_POINTS := 10

# State management to handle all toggles in one place
enum State { SPAWNED, SPAWN_ENABLED, SPAWN_DISABLED }
var _current_state: State = State.SPAWN_DISABLED

@export var base_shoot_delay: float = 1
@export var base_shoot_chance: float = 50
@export var base_revive_delay: float = 5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var revive_timer: Timer = $ReviveTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var muzzle_flash: MuzzleFlash = $MuzzleFlash
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var debug_label: Label = %DebugLabel

var enemy_level := 1
var cur_points := BASE_POINTS

## --- Lifecycle & Actions ---

func reset(cur_wave_number: int) -> void:
	enemy_level = cur_wave_number
	_update_stats()
	
	self._current_state = State.SPAWN_ENABLED
	
	visible = false
	collision_shape_2d.set_deferred("disabled", true)
	shoot_timer.stop()
	_start_revive_timer()
	
	debug_label.text = str(enemy_level)


func disable() -> void:
	visible = false
	collision_shape_2d.set_deferred("disabled", true)
	shoot_timer.stop()
	revive_timer.stop()
	self._current_state = State.SPAWN_DISABLED


func disable_spawning() -> void:
	revive_timer.stop()
	self._current_state = State.SPAWN_DISABLED


func process_smart_bomb_hit() -> void:
	enemy_hit.emit(self)
	disable()


func _update_stats() -> void:
	var cur_mult := GameManager.skills_manager.get_points_multiplier()
	cur_points = round(enemy_level * cur_mult * BASE_POINTS)


func _start_shoot_timer() -> void:
	if _current_state != State.SPAWNED:
		return
	
	var cur_delay: float = GameMath.get_exponential_decay(base_shoot_delay, enemy_level, 0.9)
	shoot_timer.start(cur_delay + randf_range(.2, 1.2))


func _start_revive_timer() -> void:
	if _current_state != State.SPAWN_ENABLED:
		return
	
	var delay: float = GameMath.get_exponential_decay(base_revive_delay + randf_range(0, 5), enemy_level, 0.9)
	revive_timer.start(delay)


func _fire_projectile() -> void:
	if _current_state != State.SPAWNED:
		return
	
	var projectile: EnemyProjectile = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.setup(-transform.y.round())
	$ShootPlayer.play()
	muzzle_flash.emit_flash()


func _spawn() -> void:
	if _current_state != State.SPAWN_ENABLED:
		return
	
	_update_stats()
	self._current_state = State.SPAWNED
	visible = true
	collision_shape_2d.set_deferred("disabled", false)
	_start_shoot_timer()
	$RevivePlayer.play()

## --- Signal Handlers ---

func _on_area_entered(projectile: PlayerProjectile) -> void:
	if _current_state != State.SPAWNED or not is_instance_valid(projectile):
		return
	
	await _hit_flash()
	
	$HitPlayer.play()
	
	if is_instance_valid(projectile):
		projectile.handle_hit()
	
	enemy_hit.emit(self)
	reset(enemy_level)


func _on_shoot_timer_timeout() -> void:
	if _current_state == State.SPAWNED:
		var cur_chance: float = GameMath.get_scaled_value(base_shoot_chance, enemy_level, 1.25)
		if GameMath.chance_check(cur_chance):
			_fire_projectile() 
		_start_shoot_timer()


func _on_revive_timer_timeout() -> void:
	_spawn()


func _hit_flash() -> void:
	if _current_state != State.SPAWNED:
		return
	
	var tween := create_tween()
	HitFlashHelper.add_hit_flash_to_tween(tween, sprite_2d)
	await tween.finished
