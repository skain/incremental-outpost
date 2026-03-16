class_name Main extends Node2D

enum GameModes {ARCADE, START_GAME, END_GAME, }

# Export the scenes so you can drag and drop them in the Inspector
@export var arcade_scene: PackedScene = preload("res://scenes/arcade/arcade_game/arcade_game.tscn")
@export var crt_scene: PackedScene = preload("res://scenes/crt/crt_panel/crt_panel.tscn")

var current_view: Node = null

func _ready() -> void:
	# Start with the initial CRT view
	_switch_game_mode(GameModes.START_GAME)

func _switch_game_mode(mode: GameModes) -> void:
	# 1. Clean up the existing view
	if current_view:
		current_view.queue_free()

	match mode:
		GameModes.ARCADE:
			var av := _set_arcade_as_current_view()
			av.start_game()
		GameModes.START_GAME:
			var crt := _set_crt_as_current_view()
			crt.run_startgame_interstitial()
		GameModes.END_GAME:
			var crt := _set_crt_as_current_view()
			crt.run_endgame_interstitial()


func _set_arcade_as_current_view() -> ArcadeGame:
	current_view = arcade_scene.instantiate()			
	current_view.game_ended.connect(_on_arcade_game_game_ended)
	add_child(current_view)
	return current_view as ArcadeGame
	
	
func _set_crt_as_current_view() -> CRTPanel:
	current_view = crt_scene.instantiate()
	_connect_crt_signals(current_view)
	add_child(current_view)
	return current_view as CRTPanel


func _connect_crt_signals(panel: CRTPanel) -> void:
	panel.return_to_outpost_clicked.connect(_start_arcade_game)
	panel.load_game_clicked.connect(_start_arcade_game)
	panel.new_game_clicked.connect(_start_arcade_game)


func _start_arcade_game() -> void:
	_switch_game_mode(GameModes.ARCADE)


func _on_arcade_game_game_ended() -> void:
	_switch_game_mode(GameModes.END_GAME)
