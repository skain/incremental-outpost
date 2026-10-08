class_name EnemySpawner extends Node2D

enum State { SPAWNED, SPAWN_ENABLED, SPAWN_DISABLED }

const BASIC_ENEMY_SCENE = preload("res://scenes/arcade/enemies/basic_enemy.tscn")
const SHIELD_GEN_ENEMY_SCENE = preload("res://scenes/arcade/enemies/shield_gen_enemy.tscn")

@onready var placeholder_sprite_2d : Sprite2D = %PlaceholderSprite2D
@onready var revive_timer : Timer = %ReviveTimer

@export var base_revive_delay := 5.0
@export var base_shield_gen_enemy_chance := 10.0
@export var shield_gen_enemy_scaling_factor := 1.5
@export var min_wave_shield_gen_enemies_enabled := 6

var _current_state : State = State.SPAWN_ENABLED
var _cur_wave_number := 1

func _ready() -> void:
	placeholder_sprite_2d.hide()


func reset(cur_wave_number: int) -> void:
	_cur_wave_number = cur_wave_number	
	self._current_state = State.SPAWN_ENABLED
	_start_revive_timer()


func disable_spawning() -> void:
	revive_timer.stop()
	self._current_state = State.SPAWN_DISABLED


func _start_revive_timer() -> void:
	if _current_state != State.SPAWN_ENABLED:
		return
	
	var delay: float = GameMath.get_exponential_decay(base_revive_delay + randf_range(0, 5), _cur_wave_number, 0.9)
	revive_timer.start(delay)


func _spawn_new_enemy() -> void:
	var enemy := _get_new_enemy_instance()
	add_child(enemy)
	enemy.spawn(_cur_wave_number)
	SignalBus.enemy_spawned.emit()


func _get_new_enemy_instance() -> Enemy:
	var shield_gen_enemy_chance := _get_shield_gen_enemy_chance()
	print("Shield gen enemy chance: %f" % shield_gen_enemy_chance)
	var roll := GameMath.chance_check(shield_gen_enemy_chance)
	var enemy : Enemy
	
	if roll:
		enemy = SHIELD_GEN_ENEMY_SCENE.instantiate()
	else:
		enemy = BASIC_ENEMY_SCENE.instantiate()
	
	return enemy


func _get_shield_gen_enemy_chance() -> float:
	if _cur_wave_number < min_wave_shield_gen_enemies_enabled:
		return 0.0
	
	#get current count on screen
	var on_screen := get_tree().get_nodes_in_group("ShieldGenEnemies").size()
	
	#calc on_screen_modifier (no chance if more than 2, 50% of chance if 1, full chance if 0)
	var on_screen_mod := 0.0
	if on_screen < 2.0:
		if on_screen > 0.0:
			on_screen_mod = 0.5
		else:
			on_screen_mod = 1
	
	#get scaled value based on cur_wave_number
	var scaled := GameMath.get_scaled_value(base_shield_gen_enemy_chance, _cur_wave_number, shield_gen_enemy_scaling_factor)
	
	return on_screen_mod * scaled

func _on_revive_timer_timeout() -> void:
	_spawn_new_enemy()
