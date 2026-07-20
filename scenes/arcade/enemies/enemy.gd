extends Area2D
class_name Enemy

const PROJECTILE_SCENE = preload("res://scenes/arcade/enemy_projectile/enemy_projectile.tscn")
const BASE_POINTS := 10
const HIT_AUDIO := preload("res://assets/sounds/8-bit Sound Library/Explosion_00.wav")
const SPAWN_AUDIO := preload("res://assets/sounds/8-bit Sound Library/Hit_01.wav")
const SHOOT_AUDIO := preload("res://assets/sounds/8-bit Sound Library/Shoot_01.wav")
const MIN_CANNON_LIGHT_ENERGY := 0.2
const MAX_CANNON_LIGHT_ENERGY := 2.0

@export var base_shoot_delay: float = 1
@export var base_shoot_chance: float = 50
@export var base_revive_delay: float = 5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var muzzle_flash: MuzzleFlash = $MuzzleFlash
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var debug_label: Label = %DebugLabel
@onready var cannon_point_light_2d: PointLight2D = %CannonPointLight2D

var enemy_level := 1
var cur_points := BASE_POINTS


func take_damage() -> void:
	await _hit_flash()
	
	SfxManager.play_sfx(HIT_AUDIO, global_position)
	
	SignalBus.enemy_hit.emit(self)
	self.call_deferred("queue_free")


func _update_stats() -> void:
	var cur_mult := GameManager.skills_manager.get_points_multiplier()
	cur_points = round(enemy_level * cur_mult * BASE_POINTS)
	debug_label.text = str(enemy_level)


func _start_shoot_timer() -> void:
	var cur_delay: float = GameMath.get_exponential_decay(base_shoot_delay, enemy_level, 0.9)
	shoot_timer.start(cur_delay + randf_range(.2, 1.2))


func _fire_projectile() -> void:
	var projectile: EnemyProjectile = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.setup(-transform.y.round())
	SfxManager.play_sfx(SHOOT_AUDIO, global_position)
	muzzle_flash.emit_flash()


func spawn(level: int) -> void:
	enemy_level = level
	_update_stats()
	
	await _tween_spawn_in()
	
	_start_cannon_light_tween()
	
	_start_shoot_timer()
	SfxManager.play_sfx(SPAWN_AUDIO, global_position)


func _start_cannon_light_tween() -> void:
	cannon_point_light_2d.energy = MIN_CANNON_LIGHT_ENERGY
	var tween := create_tween()
	tween.set_loops()
	tween.tween_property(cannon_point_light_2d, "energy", MAX_CANNON_LIGHT_ENERGY, 0.5).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cannon_point_light_2d, "energy", MIN_CANNON_LIGHT_ENERGY, 0.5).set_ease(Tween.EASE_IN_OUT)


func _tween_spawn_in() -> void:
	sprite_2d.frame = 0
	var tween := create_tween()
	tween.tween_property(sprite_2d, "frame", 2, 0.3)
	await tween.finished


func _try_shoot() -> void:
	var cur_chance: float = GameMath.get_scaled_value(base_shoot_chance, enemy_level, 1.25)
	if GameMath.chance_check(cur_chance):
		_fire_projectile()


## --- Signal Handlers ---

func _on_area_entered(projectile: Node2D) -> void:
	if not is_instance_valid(projectile):
		return
	
	take_damage()	
	
	if is_instance_valid(projectile):
		projectile.handle_hit()


func _on_shoot_timer_timeout() -> void:
	_try_shoot() 
	_start_shoot_timer()


func _hit_flash() -> void:
	var tween := create_tween()
	HitFlashHelper.add_hit_flash_to_tween(tween, sprite_2d)
	await tween.finished
