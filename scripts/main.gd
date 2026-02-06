extends Node2D

@export var game_start_sound: AudioStream
@export var game_over_sound: AudioStream

@onready var player: Player = $Player
@onready var enemy_left: Enemy = $Enemies/EnemyLeft
@onready var enemy_top: Enemy = $Enemies/EnemyTop
@onready var enemy_right: Enemy = $Enemies/EnemyRight
@onready var enemy_bottom: Enemy = $Enemies/EnemyBottom
@onready var ui: CanvasLayer = $UI
@onready var game_start_player: AudioStreamPlayer2D = $GameStartPlayer
@onready var bg_music_player: AudioStreamPlayer = %BGMusicPlayer

const BASE_SCORE := 10
var current_score := 0
var game_over := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_game()

func _start_game() -> void:
	if not game_over:
		return
		
	game_over = false
	current_score = 0
	player.reset()
	enemy_bottom.reset()
	enemy_left.reset()
	enemy_right.reset()
	enemy_top.reset()
	ui.hide_game_over()
	_update_ui()
	for i in range(6):
		Sfx.play_sfx(game_start_sound, global_position)
		# Start at 0.25s and get smaller as i increases
		# Using a negative exponent causes the value to shrink
		var delay := GameMath.get_scaled_value(0.25, i + 1, -1.5)
		await get_tree().create_timer(delay).timeout
	if not bg_music_player.playing:
		bg_music_player.play()
	
func _update_ui() -> void:
	ui.update_ui(current_score, player.health)	

		
func _end_game() -> void:
	_update_ui()
	game_over = true
	enemy_bottom.disable(false)
	enemy_left.disable(false)
	enemy_right.disable(false)
	enemy_top.disable(false)
	ui.show_game_over()
	player.die()
	Sfx.play_sfx(game_over_sound, global_position)
	bg_music_player.stop()
		

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


func _on_player_start_game_pressed() -> void:
	if game_over:
		_start_game()
