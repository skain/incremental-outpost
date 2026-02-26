class_name CRTPanel extends Node2D

signal return_to_outpost_clicked
signal load_game_clicked
signal new_game_clicked
signal upgrades_completed

@onready var background: CanvasLayer = %Background
@onready var skill_tree: SkillTree = %SkillTree
@onready var end_game_interstitial: EndGameInterstitial = %EndGameInterstitial
@onready var crt_overlay: CanvasLayer = %CRTOverlay
@onready var crt_shader: ColorRect = %CRTShader
@onready var crt_shader_mat: ShaderMaterial = %CRTShader.material
@onready var start_game_interstitial: StartGameInterstitial = %StartGameInterstitial

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	skill_tree.hide_skill_tree()
	start_game_interstitial.hide_interstitial()


func set_crt_visibility(visibility: bool) -> void:
	background.visible = visibility
	skill_tree.hide_skill_tree()

	end_game_interstitial.visible = visibility
	crt_overlay.visible = visibility
	
	
func run_startgame_interstitial() -> void:
	end_game_interstitial.hide()
	await _power_up()
	start_game_interstitial.show_interstitial()
	
func run_endgame_interstitial() -> void:
	skill_tree.hide_skill_tree()
	await _power_up()
	end_game_interstitial.run_interstitial()
	
	
func _test_screen() -> void:
	await _power_up()
	await end_game_interstitial.run_interstitial()
	await get_tree().create_timer(2.0).timeout
	await _power_down()
	
	
func _power_up() -> void:
	await _animate_power(0.0, 1.0)
	
	
func _power_down() -> void:
	await _animate_power(1.0, 0.0)
	
	
func _animate_power(from: float, to: float) -> void:
	# Create a Tween to animate it turning on
	var tween := create_tween()

	# We use tween_property with the "shader_parameter/" prefix.
	# .from(0.0) forces it to start completely black every time!
	tween.tween_property(
		crt_shader_mat, 
		"shader_parameter/power_on", 
		to, 
		0.75
	).from(from).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	
	
func _screen_off() -> void:
	crt_shader_mat.set_shader_parameter("power_on", 0.0)


func _on_end_game_interstitial_return_to_outpost_clicked() -> void:
	await _power_down()
	return_to_outpost_clicked.emit()


func _on_end_game_interstitial_upgrade_clicked() -> void:
	skill_tree.home_camera()
	end_game_interstitial.visible = false
	skill_tree.show_skill_tree()


func _on_start_game_interstitial_load_game_clicked() -> void:
	await _power_down()
	start_game_interstitial.hide_interstitial()
	load_game_clicked.emit()


func _on_start_game_interstitial_new_game_clicked() -> void:
	await _power_down()
	start_game_interstitial.hide_interstitial()
	new_game_clicked.emit()


func _on_skill_tree_upgrades_completed() -> void:
	upgrades_completed.emit()
