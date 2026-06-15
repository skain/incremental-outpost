class_name EnemySpawner extends Node2D

enum State { SPAWNED, SPAWN_ENABLED, SPAWN_DISABLED }

const ENEMY_1_SCENE = preload("uid://cmc3ik5tigjec")
const ENEMY_2_SCENE = preload("uid://ct38itdxum0sd")
const ENEMY_3_SCENE = preload("uid://c645kldb4mfr3")

@onready var placeholder_sprite_2d: Sprite2D = %PlaceholderSprite2D
@onready var revive_timer: Timer = %ReviveTimer

@export var base_revive_delay: float = 5

var _current_state: State = State.SPAWN_ENABLED
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


func _get_new_enemy_instance() -> Enemy:
	#logic to select which enemy to spawn will go here
	#for now, just use enemy1
	return ENEMY_1_SCENE.instantiate() as Enemy


func _on_revive_timer_timeout() -> void:
	_spawn_new_enemy()
