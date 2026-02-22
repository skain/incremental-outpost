class_name CRTPanel extends Node2D

signal return_to_outpost_clicked

@onready var camera_2d: Camera2D = %Camera2D
@onready var background: CanvasLayer = %Background
@onready var skill_tree_nodes: Node2D = %SkillTreeNodes
@onready var end_game_interstitial: EndGameInterstitial = %EndGameInterstitial
@onready var crt_overlay: CanvasLayer = %CRTOverlay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_visibility(visibility: bool) -> void:
	background.visible = visibility
	skill_tree_nodes.visible = visibility
	end_game_interstitial.visible = visibility
	crt_overlay.visible = visibility
	
func run_endgame_interstitial() -> void:
	skill_tree_nodes.visible = false
	end_game_interstitial.run_interstitial(100, 0.1)
	
func make_camera_current() -> void:
	camera_2d.make_current()

func _on_end_game_interstitial_return_to_outpost_clicked() -> void:
	return_to_outpost_clicked.emit()
