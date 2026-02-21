class_name CRTPanel extends Node2D

@onready var camera_2d: Camera2D = %Camera2D
@onready var background: CanvasLayer = %Background
@onready var skill_tree_nodes: Node2D = %SkillTreeNodes
@onready var end_game_interstitial: EndGameInterstitial = %EndGameInterstitial
@onready var crt_overlay: CanvasLayer = %CRTOverlay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func set_visibility(is_visible: bool) -> void:
	background.visible = is_visible
	skill_tree_nodes.visible = is_visible
	end_game_interstitial.visible = is_visible
	crt_overlay.visible = is_visible
	
func run_endgame_interstitial() -> void:
	end_game_interstitial.run_interstitial(100, 0.1)
	
func make_camera_current() -> void:
	camera_2d.make_current()
	
