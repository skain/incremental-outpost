class_name CRTPanel extends Node2D

signal return_to_outpost_clicked

@onready var skill_tree_camera: Camera2D = %SkillTreeCamera
@onready var background: CanvasLayer = %Background
@onready var skill_tree_nodes: SkillTreeNodes = %SkillTreeNodes
@onready var end_game_interstitial: EndGameInterstitial = %EndGameInterstitial
@onready var crt_overlay: CanvasLayer = %CRTOverlay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skill_tree_nodes.hide_skill_tree()

func set_crt_visibility(visibility: bool) -> void:
	background.visible = visibility
	skill_tree_nodes.visible = visibility
	end_game_interstitial.visible = visibility
	crt_overlay.visible = visibility
	
func run_endgame_interstitial() -> void:
	skill_tree_nodes.visible = false
	end_game_interstitial.run_interstitial()
	
func make_camera_current() -> void:
	skill_tree_camera.make_current()

func _on_end_game_interstitial_return_to_outpost_clicked() -> void:
	return_to_outpost_clicked.emit()


func _on_end_game_interstitial_upgrade_clicked() -> void:
	make_camera_current()
	skill_tree_nodes.home_camera()
	end_game_interstitial.visible = false
	skill_tree_nodes.visible = true
