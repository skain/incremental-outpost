class_name SkillTreeNodes extends Node2D

var root_node: SkillTreeNode = null
@onready var camera_2d: Camera2D = %Camera2D

func _ready() -> void:
	root_node = get_child(0) as SkillTreeNode

func home_camera() -> void:
	camera_2d.global_position = root_node.global_position
