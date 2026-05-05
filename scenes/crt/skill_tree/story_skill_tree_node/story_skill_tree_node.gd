class_name StorySkillTreeNode extends SkillTreeNodeBase

@export var story_subject: String
@export var story_text: String

func _ready() -> void:
	skill_cost = 0


func _set_status_from_game_data() -> void:
	if GameManager.is_node_purchased(self):
		current_status = SkillNodeStatus.PURCHASED
		return
		
	var parent := get_parent() as SkillTreeNode
	if parent:
		#this isn't the root node
		if parent.current_status != SkillNodeStatus.PURCHASED:
			current_status = SkillNodeStatus.UNREVEALED
			return
	
	if skill_cost <= GameManager.game_data.current_bucks:
		current_status = SkillNodeStatus.AFFORDABLE
	else:
		current_status = SkillNodeStatus.UNAFFORDABLE


func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("emitting")
		skill_tree_node_clicked.emit(self)
