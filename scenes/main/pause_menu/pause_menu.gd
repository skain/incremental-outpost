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
		print(name_label.text)
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
			
	#var shields_enabled := SkillsManager.get_as_bool(Enums.SkillTypes.SHIELDS_ENABLED)
	#var hull_plating := SkillsManager.get_as_int(Enums.SkillTypes.HULL_PLATING)
	#var cannon_cooldown := SkillsManager.get_as_float(Enums.SkillTypes.CANNON_COOLDOWN)
	#var shields_max := SkillsManager.get_as_float(Enums.SkillTypes.SHIELD_MAX_ENERGY)
	#var shields_drain := SkillsManager.get_as_float(Enums.SkillTypes.SHIELD_DRAIN_RATE)
	#var shields_charge := SkillsManager.get_as_float(Enums.SkillTypes.SHIELD_CHARGE_RATE)
	#var shields_timeout := SkillsManager.get_as_float(Enums.SkillTypes.SHIELD_TIMEOUT)
	#var bucks_rate := SkillsManager.get_as_float(Enums.SkillTypes.BUCKS_CONVERSION_RATE)
	#var points_mult : float = max(SkillsManager.get_as_float(Enums.SkillTypes.POINTS_MULTIPLIER), 1.0)
	#
	#shields_enabled_check_box.button_pressed = shields_enabled
	#hull_plating_label.text = str(hull_plating)
	#cannon_cooldown_label.text = "%f sec" % cannon_cooldown
	#shields_max_label.text = str(shields_max)
	#shields_drain_label.text = "%f/sec" % shields_drain
	#shields_charge_label.text = "%f /ec" % shields_charge
	#shields_timeout_label.text = "%f sec" % shields_timeout
	#bucks_rate_label.text = str(bucks_rate)
	#points_mult_label.text = "x%f" % points_mult
	


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
