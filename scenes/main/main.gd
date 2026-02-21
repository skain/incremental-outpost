extends Node2D

@export var game_start_sound: AudioStream
@export var game_over_sound: AudioStream

@onready var bg_music_player: AudioStreamPlayer = %BGMusicPlayer
@onready var player: Player = %Player
@onready var enemies: Node2D = %Enemies
@onready var arcade_game: Node2D = %ArcadeGame
@onready var crt: CRT = %CRT

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
	player.make_camera_current()
	enemies.reset_enemies()
	#ui.hide_game_over()
	_update_ui()
	arcade_game.visible = true
	crt.hide_crt()
	for i in range(6):
		Sfx.play_sfx(game_start_sound, global_position)
		# Start at 0.25s and get smaller as i increases
		# Using a negative exponent causes the value to shrink
		var delay := GameMath.get_scaled_value(0.25, i + 1, -1.5)
		await get_tree().create_timer(delay).timeout
	if not bg_music_player.playing:
		bg_music_player.play()
	
func _update_ui() -> void:
	pass
	#ui.update_ui(current_score, player.health)	

func _end_game() -> void:
	_update_ui()
	game_over = true
	enemies.disable_enemies()
	#ui.show_game_over()
	player.die()
	Sfx.play_sfx(game_over_sound, global_position)
	bg_music_player.stop()
	crt.visible = true
	arcade_game.visible = false
	crt.run_upgrader()

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
