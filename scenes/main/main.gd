extends Node2D

@onready var arcade_game: ArcadeGame = %ArcadeGame
@onready var crt_panel: CRTPanel = %CRTPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(GameManager.game_data.current_bucks)
	_start_arcade_game()

func _start_arcade_game() -> void:
	arcade_game.start_game()
	_switch_to_arcade()
	
func _switch_to_crt() -> void:
	crt_panel.set_crt_visibility(true)
	arcade_game.visible = false
	crt_panel.run_endgame_interstitial()
	
func _switch_to_arcade() -> void:
	#arcade_ui.visible = true
	arcade_game.visible = true
	crt_panel.set_crt_visibility(false)
	
func _on_crt_panel_return_to_outpost_clicked() -> void:
	_start_arcade_game()

func _on_arcade_game_game_ended() -> void:
	_switch_to_crt()
