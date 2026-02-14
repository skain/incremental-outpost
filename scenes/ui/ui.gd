class_name UI extends Node2D

@onready var game_over_panel: Panel = %GameOverPanel
@onready var arcade_overlay: ArcadeOverlay = %ArcadeOverlay
@onready var upgrade_interface: UpgradeInterface = %UpgradeInterface

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_game_over()

func update_ui(score: int, player_health: int) -> void:
	arcade_overlay.update_ui(score, player_health)

func show_game_over() -> void:
	upgrade_interface.show_upgrade_interface()
	upgrade_interface.make_camera_current()
	
func hide_game_over() -> void:
	upgrade_interface.visible = false
	upgrade_interface.hide_upgrade_interface()
