class_name EnemiesContainer extends Node2D

signal new_enemy_wave_started(wave_number: int)

var cur_wave := 0
var num_enemies_per_wave := 12
var num_enemies_left_in_current_wave := 0
var _enemies: Array[Enemy] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in find_children("*", "Enemy", false, true):
		_enemies.append(node)


func reset_enemies() -> void:
	for enemy in _enemies:
		enemy.reset(cur_wave)


func disable_enemies() -> void:
	for enemy in _enemies:
		enemy.current_state = Enemy.State.DISABLED


func start_new_enemy_wave() -> void:
	num_enemies_left_in_current_wave = num_enemies_per_wave
	cur_wave += 1
	reset_enemies()
	new_enemy_wave_started.emit(cur_wave)


func start_new_game() -> void:
	cur_wave = 0
	start_new_enemy_wave()


func _decrement_and_manage_enemy_wave() -> void:
	num_enemies_left_in_current_wave -= 1
	if num_enemies_left_in_current_wave <= 0:
		start_new_enemy_wave()


#func connect_hit_handler(handler: Callable) -> void:
	#for enemy in _enemies:
		#enemy.enemy_hit.connect(handler)


func _on_enemy_hit(enemy: Enemy) -> void:
	_decrement_and_manage_enemy_wave()
