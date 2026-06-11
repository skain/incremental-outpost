class_name EnemiesContainer extends Node2D

signal new_enemy_wave_started(wave_number: int)

var cur_wave := 0
var num_enemies_per_wave := 6
var num_enemies_left_in_current_wave := 0
var _enemy_spawners: Array[EnemySpawner] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.enemy_hit.connect(_on_enemy_hit)
	for node in find_children("*", "EnemySpawner", false, true):
		_enemy_spawners.append(node)


func reset_enemies() -> void:
	for _enemy_spawner in _enemy_spawners:
		_enemy_spawner.reset(cur_wave)


func _disable_enemy_spawning() -> void:
	for _enemy_spawner in _enemy_spawners:
		_enemy_spawner.disable_spawning()


func start_new_enemy_wave() -> void:
	num_enemies_left_in_current_wave = num_enemies_per_wave
	cur_wave += 1
	_disable_enemy_spawning()
	
	# This is a lame work around to keeping track of live enemies
	if cur_wave > 1:
		await get_tree().create_timer(5).timeout
	
	reset_enemies()
	new_enemy_wave_started.emit(cur_wave)


func _check_enemies_exist() -> bool:
	var _enemy := get_tree().get_first_node_in_group("Enemy")
	return true if _enemy else false


func start_new_game() -> void:
	cur_wave = 0
	start_new_enemy_wave()


func _decrement_and_manage_enemy_wave() -> void:
	num_enemies_left_in_current_wave -= 1
	if num_enemies_left_in_current_wave <= 0:
		start_new_enemy_wave()


func _on_enemy_hit(_enemy_spawner: Enemy) -> void:
	_decrement_and_manage_enemy_wave()
