class_name EnemiesContainer extends Node2D

signal new_enemy_wave_started(wave_number: int)

var cur_wave := 0
var num_enemies_per_wave := 6

var _enemies_spawned_so_far := 0
var _spawning_completed_for_wave := false
var _enemy_spawners: Array[EnemySpawner] = []

func _ready() -> void:
	SignalBus.enemy_spawned.connect(_on_enemy_spawned)
	get_tree().node_removed.connect(_on_node_removed)
	
	for node in find_children("*", "EnemySpawner", false, true):
		_enemy_spawners.append(node)


func reset_enemies() -> void:
	for _enemy_spawner in _enemy_spawners: 
		_enemy_spawner.reset(cur_wave) 


func _disable_enemy_spawning() -> void:
	for _enemy_spawner in _enemy_spawners: 
		_enemy_spawner.disable_spawning() 


func start_new_enemy_wave() -> void:
	_spawning_completed_for_wave = false
	_enemies_spawned_so_far = 0
	cur_wave += 1 
	_disable_enemy_spawning() 
	
	reset_enemies() 
	new_enemy_wave_started.emit(cur_wave) 


func _check_enemies_exist() -> bool:
	var _enemy := get_tree().get_first_node_in_group("Enemy") 
	return true if _enemy else false 


func start_new_game() -> void:
	cur_wave = 0 
	start_new_enemy_wave() 


func _on_enemy_spawned() -> void:
	_enemies_spawned_so_far += 1
	
	if _enemies_spawned_so_far >= num_enemies_per_wave:
		_disable_enemy_spawning()
		_spawning_completed_for_wave = true
		
		# Just in case all enemies somehow died before the last one spawned 
		_check_wave_progression()


func _on_node_removed(node: Node) -> void:
	if node.is_in_group("Enemy"):
		await get_tree().physics_frame
		_check_wave_progression()


func _check_wave_progression() -> void:
	if _spawning_completed_for_wave and not _check_enemies_exist():
		start_new_enemy_wave()
