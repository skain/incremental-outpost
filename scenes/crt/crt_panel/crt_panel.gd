class_name CRTPanel extends Node2D

signal return_to_outpost_clicked

@onready var skill_tree_camera: Camera2D = %SkillTreeCamera
@onready var background: CanvasLayer = %Background
@onready var skill_tree_nodes: SkillTreeNodes = %SkillTreeNodes
@onready var end_game_interstitial: EndGameInterstitial = %EndGameInterstitial
@onready var crt_overlay: CanvasLayer = %CRTOverlay
@onready var crt_shader: ColorRect = %CRTShader
@onready var crt_shader_mat: ShaderMaterial = %CRTShader.material

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_screen_off()
	skill_tree_nodes.hide_skill_tree()

func set_crt_visibility(visibility: bool) -> void:
	background.visible = visibility
	skill_tree_nodes.visible = visibility
	end_game_interstitial.visible = visibility
	crt_overlay.visible = visibility
	
func run_endgame_interstitial() -> void:
	skill_tree_nodes.visible = false
	await _power_up()
	end_game_interstitial.run_interstitial()
	
func make_camera_current() -> void:
	skill_tree_camera.make_current()

	
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
	make_camera_current()
	skill_tree_nodes.home_camera()
	end_game_interstitial.visible = false
	skill_tree_nodes.visible = true
