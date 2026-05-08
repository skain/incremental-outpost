extends Area2D
class_name Enemy

signal enemy_hit(enemy: Enemy)

const PROJECTILE_SCENE = preload("res://scenes/arcade/enemy_projectile/enemy_projectile.tscn")
const BASE_POINTS := 10

# State management to handle all toggles in one place
enum State { ACTIVE, RECHARGING, DISABLED }
var current_state: State = State.DISABLED: set = set_state

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

## --- State Controller ---

func set_state(new_state: State) -> void:
	current_state = new_state
	
	match current_state:
		State.ACTIVE:
			visible = true
			collision_shape_2d.set_deferred("disabled", false)
			_start_shoot_timer()
			$RevivePlayer.play()
		State.RECHARGING:
			visible = false
			collision_shape_2d.set_deferred("disabled", true)
			shoot_timer.stop()
			_start_revive_timer()
		State.DISABLED:
			visible = false
			collision_shape_2d.set_deferred("disabled", true)
			shoot_timer.stop()
			revive_timer.stop()

## --- Lifecycle & Actions ---

func reset() -> void:
	_update_stats()
	self.current_state = State.RECHARGING
	debug_label.text = str(enemy_level)

func _update_stats() -> void:
	enemy_level = GameManager.get_current_enemy_wave_level()
	var cur_mult := GameManager.skills_manager.get_points_multiplier()
	cur_points = round(enemy_level * cur_mult * BASE_POINTS)

func _start_shoot_timer() -> void:
	var cur_delay: float = GameMath.get_scaled_value(base_shoot_delay, enemy_level, -1.1)
	shoot_timer.start(cur_delay + randf_range(.2, 1.2))

func _start_revive_timer() -> void:
	var delay: float = GameMath.get_scaled_value(base_revive_delay + randf_range(0, 5), enemy_level, -1.1)
	revive_timer.start(delay)

func _fire_projectile() -> void:
	var projectile: EnemyProjectile = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile)
	projectile.global_position = global_position
	projectile.setup(-transform.y.round())
	$ShootPlayer.play()
	muzzle_flash.emit_flash()

## --- Signal Handlers ---

func _on_area_entered(area: Area2D) -> void:
	# 1. Immediate Safety Check: If it's freed or null, get out now.
	if not is_instance_valid(area):
		return

	# 2. Capture the type before the await
	var was_player_projectile := area is PlayerProjectile
	
	# 3. Visuals (The 'await' that allows the projectile to be freed)
	await _hit_flash()
	
	# 4. State Change logic
	self.current_state = State.RECHARGING
	$HitPlayer.play()
	
	# 5. Final Safety Check: Check again before calling handle_hit()
	if was_player_projectile and is_instance_valid(area):
		area.handle_hit()
	
	enemy_hit.emit(self)

func _on_shoot_timer_timeout() -> void:
	if current_state == State.ACTIVE:
		var cur_chance: float = GameMath.get_scaled_value(base_shoot_chance, enemy_level, 1.25)
		if GameMath.chance_check(cur_chance):
			_fire_projectile() 
		_start_shoot_timer()

func _on_revive_timer_timeout() -> void:
	_update_stats()
	self.current_state = State.ACTIVE

func _hit_flash() -> void:
	var tween := create_tween()
	HitFlashHelper.add_hit_flash_to_tween(tween, sprite_2d)
	await tween.finished
