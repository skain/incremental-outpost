class_name SkillTreeNodes extends Node2D

var root_node: SkillTreeNode = null
@onready var skill_tree_camera: Camera2D = %SkillTreeCamera

func _ready() -> void:
	root_node = get_child(0) as SkillTreeNode

func home_camera() -> void:
	skill_tree_camera.zoom = Vector2.ONE
	skill_tree_camera.global_position = root_node.global_position
