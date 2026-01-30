extends Node2D

@onready var player: Player = $Player
@onready var enemy_left: Enemy = $Enemies/EnemyLeft
@onready var enemy_top: Enemy = $Enemies/EnemyTop
@onready var enemy_right: Enemy = $Enemies/EnemyRight
@onready var enemy_bottom: Enemy = $Enemies/EnemyBottom
@onready var game_over_panel: Panel = $CanvasLayer/GameOverPanel
@onready var ui: CanvasLayer = $UI

const BASE_SCORE := 10
var current_score := 0
var game_over := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	
func _update_ui() -> void:
	ui.update_ui(current_score, player.health)	

		
func _end_game() -> void:
	_update_ui()
	ui.show_game_over()
	player.die()
	enemy_bottom.disable(false)
	enemy_left.disable(false)
	enemy_right.disable(false)
	enemy_top.disable(false)
	game_over = true
		

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
	#print(player.health)


func _on_player_start_game_pressed() -> void:
	if game_over:
		_start_game()
