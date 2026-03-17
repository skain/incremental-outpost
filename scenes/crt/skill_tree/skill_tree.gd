class_name SkillTree extends Node2D

signal upgrades_completed

var root_node: SkillTreeNode = null

@onready var skill_tree_camera: Camera2D = %SkillTreeCamera
@onready var skill_tree_ui: SkillTreeUI = %SkillTreeUI
@onready var skill_tree_music: AudioStreamPlayer = %SkillTreeMusic

func _ready() -> void:
	root_node = get_child(0) as SkillTreeNode
	_connect_skill_node_signals()
	
	
func _connect_skill_node_signals() -> void:
	for node in find_children("*", "SkillTreeNode", true, false):
		var skill_node := node as SkillTreeNode
		if skill_node:
			skill_node.skill_tree_node_clicked.connect(_on_skill_tree_node_clicked)
			

func home_camera() -> void:
	skill_tree_camera.make_current()
	skill_tree_camera.zoom = Vector2.ONE
	skill_tree_camera.global_position = root_node.global_position
	

func show_skill_tree() -> void:
	_update_ui()
	show()
	skill_tree_ui.show_skill_tree_ui()
	if not skill_tree_music.playing:
		skill_tree_music.play()
	
	
func hide_skill_tree() -> void:
	hide()
	skill_tree_ui.hide_skill_tree_ui()
	skill_tree_music.stop()
	

func _update_ui() -> void:
	skill_tree_ui.update_ui()
	root_node.update_from_game_data(true)	
	
	
func _on_skill_tree_node_clicked(node: SkillTreeNode) -> void:
	skill_tree_ui.show_skill_node_info(node)


func _on_return_to_outpost_button_pressed() -> void:
	upgrades_completed.emit()


func _on_skill_tree_ui_buy_skill_node_pressed(node: SkillTreeNode) -> void:
	GameManager.process_node_purchase(node)
	_update_ui()
