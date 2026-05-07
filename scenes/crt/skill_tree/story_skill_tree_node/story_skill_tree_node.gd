class_name StorySkillTreeNode extends SkillTreeNodeBase

@export var story_subject: String
@export var story_text: String


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("emitting")
		skill_tree_node_clicked.emit(self)
