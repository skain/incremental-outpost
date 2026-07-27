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
	var shields_enabled := SkillsManager.get_as_bool(Enums.SkillTypes.SHIELDS_ENABLED)
	var hull_plating := SkillsManager.get_as_int(Enums.SkillTypes.HULL_PLATING)
	var cannon_cooldown := SkillsManager.get_as_float(Enums.SkillTypes.CANNON_COOLDOWN)
	var shields_max := SkillsManager.get_as_float(Enums.SkillTypes.SHIELD_MAX_ENERGY)
	var shields_drain := SkillsManager.get_as_float(Enums.SkillTypes.SHIELD_DRAIN_RATE)
	var shields_charge := SkillsManager.get_as_float(Enums.SkillTypes.SHIELD_CHARGE_RATE)
	var shields_timeout := SkillsManager.get_as_float(Enums.SkillTypes.SHIELD_TIMEOUT)
	var bucks_rate := SkillsManager.get_as_float(Enums.SkillTypes.BUCKS_CONVERSION_RATE)
	var points_mult : float = max(SkillsManager.get_as_float(Enums.SkillTypes.POINTS_MULTIPLIER), 1.0)
	
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
