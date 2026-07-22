class_name SkillTreeUI extends CanvasLayer

signal buy_skill_node_pressed(node: SkillTreeNodeBase)

@onready var skill_node_info_container: SkillNodeInfoContainer = %SkillNodeInfoContainer
@onready var bucks_label: Label = %BucksLabel
@onready var respec_confirmation_dialog: SkillNodeInfoContainer = %RespecConfirmationDialog
@onready var respec_button: Button = %RespecButton

func _ready() -> void:
	respec_button.visible =  SkillsManager.get_respec_enabled()

func update_ui() -> void:
	bucks_label.text = "$ : " + str(GameManager.game_data.current_bucks)


func show_skill_tree_ui() -> void:
	show()
	skill_node_info_container.hide()
	
	
func hide_skill_tree_ui() -> void:
	hide()
	skill_node_info_container.hide()
	

func show_skill_node_info(node: SkillTreeNodeBase) -> void:
	skill_node_info_container.show()
	skill_node_info_container.load_node_info(node)
	
	
func _on_skill_node_info_container_close_button_pressed() -> void:
	skill_node_info_container.hide()


func _on_skill_node_info_container_buy_button_pressed(node: SkillTreeNodeBase) -> void:
	buy_skill_node_pressed.emit(node)
	var stn := node as SkillTreeNode
	if stn:
		if stn.affected_stat == SkillTreeNode.AffectedStat.RESPEC_ENABLED:
			# respec enabled was just purchased so show the button
			respec_button.show()
	skill_node_info_container.hide()


func _on_respec_pressed() -> void:
	respec_confirmation_dialog.show()


func _on_yes_respec_button_pressed() -> void:
	respec_confirmation_dialog.hide()
	SignalBus.respec_requested.emit()


func _on_no_respec_button_pressed() -> void:
	respec_confirmation_dialog.hide()
