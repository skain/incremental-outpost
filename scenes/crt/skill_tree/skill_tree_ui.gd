class_name SkillTreeUI extends CanvasLayer

signal buy_skill_node_pressed(node: SkillTreeNode)

@onready var skill_node_info_container: SkillNodeInfoContainer = %SkillNodeInfoContainer


func show_skill_tree_ui() -> void:
	visible = true
	skill_node_info_container.visible = false
	
	
func hide_skill_tree_ui() -> void:
	visible = false
	skill_node_info_container.visible = false
	

func show_skill_node_info(node: SkillTreeNode) -> void:
	skill_node_info_container.visible = true
	skill_node_info_container.load_node_info(node)
	
	
func _on_skill_node_info_container_close_button_pressed() -> void:
	skill_node_info_container.visible = false


func _on_skill_node_info_container_buy_button_pressed(node: SkillTreeNode) -> void:
	buy_skill_node_pressed.emit(node)
