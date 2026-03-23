class_name CRTPanel extends Node2D

signal return_to_outpost_clicked
signal load_game_clicked
signal new_game_clicked

const SAVE_ICON_MIN_MOD = Color.WHITE * Color(1.0, 1.0, 1.0, 0.25)
const SAVE_ICON_MAX_MOD = Color.WHITE * Color(1.5, 1.5, 1.5, 1.0)

@export var start_interstitial_scene: PackedScene = preload("res://scenes/crt/start_game_interstitial/start_game_interstitial.tscn")
@export var end_interstitial_scene: PackedScene = preload("res://scenes/crt/end_game_interstitial/end_game_interstitial.tscn")
@export var skill_tree_scene: PackedScene = preload("res://scenes/crt/skill_tree/skill_tree.tscn")

@onready var view_container: Node2D = %ViewContainer
@onready var crt_shader_mat: ShaderMaterial = %CRTShader.material
@onready var save_icon: Sprite2D = %SaveIcon

var current_sub_view: Node = null
var save_icon_tween: Tween = null

func _ready() -> void:
	# Initial state is usually off/hidden until run_ functions are called
	_screen_off() 
	await _power_up()
	_show_save_icon()
	#run_endgame_interstitial()

func _switch_sub_view(next_scene: PackedScene) -> Node:
	if current_sub_view:
		current_sub_view.queue_free()

	current_sub_view = next_scene.instantiate()
	view_container.add_child(current_sub_view)
	return current_sub_view

# Called by main.gd
func run_startgame_interstitial() -> void:
	var view := _switch_sub_view(start_interstitial_scene)
	view.load_game_clicked.connect(func() -> void: _on_start_finished(load_game_clicked))
	view.new_game_clicked.connect(func() -> void: _on_start_finished(new_game_clicked))

	await _power_up() 
	view.show_interstitial()

# Called by main.gd
func run_endgame_interstitial() -> void:
	var view := _switch_sub_view(end_interstitial_scene)
	view.return_to_outpost_clicked.connect(_on_return_requested)
	view.upgrade_clicked.connect(_on_upgrade_clicked)

	await _power_up() 
	view.run_interstitial()

func _on_start_finished(sig: Signal) -> void:
	await _power_down() 
	sig.emit()

func _on_return_requested() -> void:
	await _power_down() 
	return_to_outpost_clicked.emit()

func _on_upgrade_clicked() -> void:
	var tree := _switch_sub_view(skill_tree_scene)
	tree.upgrades_completed.connect(_on_return_requested)
	tree.home_camera()
	tree.show_skill_tree()
	
#func _test_screen() -> void:
	#await _power_up()
	#await end_game_interstitial.run_interstitial()
	#await get_tree().create_timer(2.0).timeout
	#await _power_down()
	

func _show_save_icon() -> void:
	if save_icon_tween:
		return
	
	#fade in
	save_icon_tween = create_tween()
	save_icon_tween.tween_property(save_icon, "self_modulate", SAVE_ICON_MIN_MOD, 0.25)
	await save_icon_tween.finished

	#flash
	save_icon_tween = create_tween()
	save_icon_tween.tween_property(save_icon, "self_modulate", SAVE_ICON_MAX_MOD, 0.5)
	save_icon_tween.tween_property(save_icon, "self_modulate", SAVE_ICON_MIN_MOD, 0.5)
	save_icon_tween.set_loops(3)
	
	await save_icon_tween.finished
	
	#fade out
	save_icon_tween = create_tween()
	save_icon_tween.tween_property(save_icon, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 0.25)

func _power_up() -> void:
	await _animate_power(0.0, 1.0)
	
	
func _power_down() -> void:
	await _animate_power(1.0, 0.0)
	
func _screen_off() -> void:
	crt_shader_mat.set_shader_parameter("power_on", 0.0)
	
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
