extends Node2D

@onready var arcade_game: ArcadeGame = %ArcadeGame
@onready var crt_panel: CRTPanel = %CRTPanel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_switch_to_startgame()

func _start_arcade_game() -> void:
	_switch_to_arcade()
	arcade_game.start_game()


func _show_crt() -> void:	
	crt_panel.set_crt_visibility(true)
	arcade_game.visible = false
	
	
func _hide_crt() -> void:
	crt_panel.set_crt_visibility(false)
	
	
func _switch_to_endgame() -> void:
	_show_crt()
	crt_panel.run_endgame_interstitial()
	
	
func _switch_to_startgame() -> void:
	_show_crt()
	crt_panel.run_startgame_interstitial()
	
	
func _switch_to_arcade() -> void:
	#arcade_ui.visible = true
	arcade_game.visible = true
	_hide_crt()
	
	
func _on_crt_panel_return_to_outpost_clicked() -> void:
	_start_arcade_game()
	

func _on_arcade_game_game_ended() -> void:
	_switch_to_endgame()


func _on_crt_panel_load_game_clicked() -> void:
	_start_arcade_game()


func _on_crt_panel_new_game_clicked() -> void:
	_start_arcade_game()


func _on_crt_panel_upgrades_completed() -> void:
	_start_arcade_game()
