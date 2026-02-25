class_name ArcadeGame extends Node2D

signal game_ended

const BASE_SCORE := 10
var current_score := 0
var game_over := true

@export var game_start_sound: AudioStream
@export var game_over_sound: AudioStream
@onready var bg_music_player: AudioStreamPlayer = %BGMusicPlayer
@onready var player: Player = %Player
@onready var enemies: Node2D = %Enemies
@onready var arcade_ui: CanvasLayer = %ArcadeUI

func _ready() -> void:
	_connect_enemy_hits()
	
func _connect_enemy_hits() -> void:
	for node in enemies.find_children("*", "Enemy"):
		var enemy := node as Enemy
		enemy.enemy_hit.connect(_on_enemy_hit)
		
func start_game() -> bool:
	if not game_over:
		return false
		
	game_over = false
	current_score = 0
	enemies.reset_enemies()	
	player.reset()
	arcade_ui.visible = true
	player.make_camera_current()
	_update_ui()
	for i in range(6):
		SfxManager.play_sfx(game_start_sound, global_position)
		# Start at 0.25s and get smaller as i increases
		# Using a negative exponent causes the value to shrink
		var delay := GameMath.get_scaled_value(0.25, i + 1, -1.5)
		await get_tree().create_timer(delay).timeout
	if not bg_music_player.playing:
		bg_music_player.play()
		
		
	return true
	
func _end_game() -> void:
	game_over = true
	_update_ui()
	enemies.disable_enemies()
	arcade_ui.visible = false
	player.die()
	SfxManager.play_sfx(game_over_sound, global_position)
	bg_music_player.stop()
	GameManager.set_points(current_score)
	game_ended.emit()

func _update_ui() -> void:
	arcade_ui.update_ui(current_score, player.health)	

func _on_enemy_hit(enemy: Enemy) -> void:
	current_score += enemy.enemy_level * BASE_SCORE
	_update_ui()
	enemy.enemy_level += 1

func _on_player_player_hit() -> void:	
	player.health -= 1
	if player.health < 1:
		_end_game()
		return
	_update_ui()

	
