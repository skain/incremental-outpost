class_name PauseMenu extends CanvasLayer

signal resume_pressed

@onready var stats_button: Button = %StatsButton
@onready var stats_panel: PanelContainer = %StatsPanel
@onready var shields_enabled_check_box: CheckBox = %ShieldsEnabledCheckBox
@onready var hull_plating_label: Label = %HullPlatingLabel
@onready var cannon_cooldown_label: Label = %CannonCooldownLabel
@onready var shields_max_label: Label = %ShieldsMaxLabel
@onready var shields_drain_label: Label = %ShieldsDrainLabel
@onready var shields_charge_label: Label = %ShieldsChargeLabel
@onready var shields_timeout_label: Label = %ShieldsTimeoutLabel
@onready var bucks_rate_label: Label = %BucksRateLabel
@onready var no_data_container: PanelContainer = %NoDataContainer
@onready var points_mult_label: Label = %PointsMultLabel

func _ready() -> void:
	stats_panel.hide()
	no_data_container.hide()


func _load_stats() -> void:
	var shields_enabled := SkillsManager.get_shields_enabled()
	var hull_plating := SkillsManager.get_hull_plating()
	var cannon_cooldown := SkillsManager.get_cannon_cooldown()
	var shields_max := SkillsManager.get_shield_max_energy()
	var shields_drain := SkillsManager.get_shield_drain_rate()
	var shields_charge := SkillsManager.get_shield_charge_rate()
	var shields_timeout := SkillsManager.get_shield_timeout()
	var bucks_rate := SkillsManager.get_points_to_bucks_conversion_rate()
	var points_mult := SkillsManager.get_points_multiplier()
	
	shields_enabled_check_box.button_pressed = shields_enabled
	hull_plating_label.text = str(hull_plating)
	cannon_cooldown_label.text = "%f sec" % cannon_cooldown
	shields_max_label.text = str(shields_max)
	shields_drain_label.text = "%f/sec" % shields_drain
	shields_charge_label.text = "%f /ec" % shields_charge
	shields_timeout_label.text = "%f sec" % shields_timeout
	bucks_rate_label.text = str(bucks_rate)
	points_mult_label.text = "x%f" % points_mult
	


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
