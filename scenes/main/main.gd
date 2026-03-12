extends Node2D

# Export the scenes so you can drag and drop them in the Inspector
@export var arcade_scene: PackedScene = preload("res://scenes/arcade/arcade_game/arcade_game.tscn")
@export var crt_scene: PackedScene = preload("res://scenes/crt/crt_panel/crt_panel.tscn")

var current_view: Node = null

func _ready() -> void:
	# Start with the initial CRT view
	_switch_to_view(crt_scene, "startgame")

func _switch_to_view(next_packed_scene: PackedScene, mode: String = "") -> void:
	# 1. Clean up the existing view
	if current_view:
		current_view.queue_free()

	# 2. Instance and add the new one
	current_view = next_packed_scene.instantiate()
	add_child(current_view)

	# 3. Dynamic Signal & State Handling
	if current_view is ArcadeGame:
		current_view.game_ended.connect(_on_arcade_game_game_ended)
		current_view.start_game()
		
	elif current_view is CRTPanel:
		_connect_crt_signals(current_view)
		
		# Handle the different CRT states (start/end/upgrade)
		match mode:
			"startgame": current_view.run_startgame_interstitial()
			"endgame": current_view.run_endgame_interstitial()
			"upgrade": current_view.set_crt_visibility(true)

func _connect_crt_signals(panel: CRTPanel) -> void:
	panel.return_to_outpost_clicked.connect(_start_arcade_game)
	panel.load_game_clicked.connect(_start_arcade_game)
	panel.new_game_clicked.connect(_start_arcade_game)

func _start_arcade_game() -> void:
	_switch_to_view(arcade_scene)

func _on_arcade_game_game_ended() -> void:
	_switch_to_view(crt_scene, "endgame")
