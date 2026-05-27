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

func _ready() -> void:
	enemies.disable_enemies()
	#enemies.connect_hit_handler(_on_enemy_hit)
		
		
func start_game() -> void:
	game_over = false
	current_score = 0
	enemies.start_new_game()
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


func _on_player_shield_energy_ui_update_requested(cur_shield_energy: float, cur_shield_energy_max: float) -> void:
	arcade_ui.update_shield_energy(cur_shield_energy, cur_shield_energy_max)


func _on_player_shield_cooldown_ui_update_requested(shield_cooldown_max: float, shield_cooldown_cur_value: float) -> void:
	arcade_ui.update_shield_cooldown(shield_cooldown_max, shield_cooldown_cur_value)


func _on_enemies_new_enemy_wave_started(wave_number: int) -> void:
	arcade_ui.show_new_wave_message(wave_number)
