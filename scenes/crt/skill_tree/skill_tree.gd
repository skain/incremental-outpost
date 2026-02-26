class_name SkillTree extends Node2D

var root_node: SkillTreeNode = null

@onready var skill_tree_camera: Camera2D = %SkillTreeCamera
@onready var skill_tree_ui: CanvasLayer = %SkillTreeUI
@onready var skill_node_info_container: SkillNodeInfoContainer = %SkillNodeInfoContainer
@onready var bucks_label: Label = %BucksLabel

func _ready() -> void:
	root_node = get_child(0) as SkillTreeNode
	_connect_skill_node_signals()
	hide_skill_tree()
	
	
func _connect_skill_node_signals() -> void:
	for node in find_children("*", "SkillTreeNode", true, false):
		var skill_node := node as SkillTreeNode
		if skill_node:
			skill_node.skill_tree_node_clicked.connect(_on_skill_tree_node_clicked)
			

func _show_skill_node_info(node: SkillTreeNode) -> void:
	skill_node_info_container.visible = true
	skill_node_info_container.load_node_info(node)
	
	
func _hide_skill_node_info() -> void:
	skill_tree_ui.visible = false
	

func home_camera() -> void:
	skill_tree_camera.make_current()
	skill_tree_camera.zoom = Vector2.ONE
	skill_tree_camera.global_position = root_node.global_position
	

func show_skill_tree() -> void:
	_update_ui()
	visible = true
	skill_tree_ui.visible = true
	skill_node_info_container.visible = false
	
	
func hide_skill_tree() -> void:
	visible = false
	skill_tree_ui.visible = false
	skill_node_info_container.visible = false
	

func _update_ui() -> void:
	print(GameManager.game_data.current_bucks)
	bucks_label.text = "B : " + str(GameManager.game_data.current_bucks)
	
	
	
func _on_skill_tree_node_clicked(node: SkillTreeNode) -> void:
	print(node.name + " clicked")
	_show_skill_node_info(node)


func _on_close_button_pressed() -> void:
	_hide_skill_node_info()
