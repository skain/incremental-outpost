class_name PauseMenu extends CanvasLayer

signal resume_pressed

@onready var stats_button: Button = %StatsButton
@onready var stats_panel: PanelContainer = %StatsPanel
@onready var no_data_container: PanelContainer = %NoDataContainer
@onready var stats_container: GridContainer = %StatsContainer

func _ready() -> void:
	hide()
	stats_panel.hide()
	no_data_container.hide()


func _load_stats() -> void:
	var stat_names := Enums.SkillTypes.keys().duplicate()
	stat_names.sort()
	for stat_name :String in stat_names:
		var name_label := Label.new()
		name_label.text = stat_name.replace("_", " ")
		stats_container.add_child(name_label)
		
		var enum_val :int = Enums.SkillTypes.get(stat_name)
		if stat_name.contains("ENABLED"):
			var cb := CheckBox.new()
			cb.button_pressed = SkillsManager.get_as_bool(enum_val)
			stats_container.add_child(cb)
		else:
			var val_label := Label.new()
			var format_str := "%.2f"
			if stat_name.contains("COOLDOWN"):
				format_str = "%.2f secs"
			elif stat_name.contains("RATE"):
				format_str = "%.2f/sec"
			val_label.text = format_str % SkillsManager.get_as_float(enum_val)
			
			stats_container.add_child(val_label)


func _on_resume_button_pressed() -> void:
	resume_pressed.emit()


func _on_close_button_pressed() -> void:
	stats_panel.hide()


func _on_stats_button_pressed() -> void:
	if GameManager.has_nodes_registered():
		_load_stats()
		stats_panel.show()
	else:
		no_data_container.show()


func _on_close_no_data_button_pressed() -> void:
	no_data_container.hide()
