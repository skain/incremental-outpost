class_name ArcadeGame extends Node2D

signal game_ended

var current_score := 0
var game_over := true

const POOF_LABEL_SCENE := preload("res://scenes/arcade/poof_label/poof_label.tscn")

@export var game_start_sound: AudioStream
@export var game_over_sound: AudioStream
@onready var bg_music_player: AudioStreamPlayer = %BGMusicPlayer
@onready var player: Player = %Player
@onready var enemies: EnemiesContainer = %Enemies
@onready var arcade_ui: ArcadeUI = %ArcadeUI
@onready var smart_bomb_screen_effect: SmartBombScreenEffect = %SmartBombScreenEffect

func _ready() -> void:
	enemies.disable_enemies()
		
		
func start_game() -> void:
	game_over = false
	current_score = 0
	enemies.start_new_game()
	SignalBus.enemy_hit.connect(_on_enemy_hit)
	player.reset()
	arcade_ui.show()
	player.make_camera_current()
	_update_ui()
	_play_startup_sound()
	_start_bg_music()


func _start_bg_music() -> void:
	if not bg_music_player.playing:
		bg_music_player.play()


func _play_startup_sound() -> void:	
	for i in range(6):
		SfxManager.play_sfx(game_start_sound, global_position)
		# Start at 0.25s and get smaller as i increases
		# Using a negative exponent causes the value to shrink
		var delay := GameMath.get_scaled_value(0.25, i + 1, -1.5)
		await get_tree().create_timer(delay).timeout


func _end_game() -> void:
	game_over = true
	_update_ui()
	enemies.disable_enemies()
	arcade_ui.hide()
	player.die()
	SfxManager.play_sfx(game_over_sound, global_position)
	bg_music_player.stop()
	GameManager.set_points(current_score)
	game_ended.emit()


func _update_ui() -> void:
	arcade_ui.update_ui(current_score, player.hull_plating)	


func _handle_smart_bomb() -> void:
	get_tree().paused = true
	await smart_bomb_screen_effect.trigger()
	get_tree().paused = false
	_destroy_all_projectiles()
	_smart_bomb_all_enemies()
	await get_tree().create_timer(3).timeout
	enemies.reset_enemies()


func _smart_bomb_all_enemies() -> void:
	var enemies : Array[Enemy] = []
	enemies.assign(get_tree().get_nodes_in_group("Enemy"))
	
	for e in enemies:
		e.process_smart_bomb_hit()


func _destroy_all_projectiles() -> void:
	var projectiles := get_tree().get_nodes_in_group("PlayerProjectile")
	projectiles.append_array(get_tree().get_nodes_in_group("EnemyProjectile"))
	
	for p in projectiles:
		p.call_deferred("queue_free")


# Signal Handlers
func _on_enemy_hit(enemy: Enemy) -> void:
	var points := enemy.cur_points
	current_score += points
	var text_popup := POOF_LABEL_SCENE.instantiate() as PoofLabel
	get_tree().current_scene.add_child(text_popup)
	var middle := Vector2(320.0, 320.0)
	var direction := (middle - enemy.global_position) / 2.0
	text_popup.travel_distance = direction
	text_popup.start(str(points), enemy.global_position)
	_update_ui()


func _on_player_player_hit() -> void:	
	player.hull_plating -= 1
	if player.hull_plating < 0:
		_end_game()
		return
	_update_ui()


func _on_enemies_new_enemy_wave_started(wave_number: int) -> void:
	arcade_ui.show_new_wave_message(wave_number)


func _on_player_smart_bomb_triggered() -> void:
	_handle_smart_bomb()
