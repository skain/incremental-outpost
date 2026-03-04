class_name SkillTreeUI extends CanvasLayer

signal buy_skill_node_pressed(node: SkillTreeNode)
signal info_container_close_button_pressed


func _on_skill_node_info_container_close_button_pressed() -> void:
	info_container_close_button_pressed.emit()


func _on_skill_node_info_container_buy_button_pressed(node: SkillTreeNode) -> void:
	buy_skill_node_pressed.emit(node)
