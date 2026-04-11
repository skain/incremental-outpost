class_name ArcadeUI extends CanvasLayer

const TOTAL_MAX_SHIELD_ENERGY := 300.0

@onready var score_value: Label = %ScoreValue
@onready var hull_plating_1: TextureRect = %HullPlating1
@onready var hull_plating_2: TextureRect = %HullPlating2
@onready var hull_plating_3: TextureRect = %HullPlating3
@onready var new_wave_label: Label = %NewWaveLabel
@onready var shield_energy_h_box_container: HBoxContainer = %ShieldEnergyHBoxContainer
@onready var shield_progress_bar: ProgressBar = %ShieldProgressBar

var new_wave_label_tween: Tween


func _ready() -> void:
	if GameManager.get_modifier_value(SkillNodeResource.AffectedStat.SHIELDS_ENABLED):
		shield_energy_h_box_container.show()
	else:
		shield_energy_h_box_container.hide()


func update_ui(score: int, player_hull_plating: int) -> void:
	score_value.text = str(score)
	_set_player_hull_plating(player_hull_plating)	


func update_shield_energy(cur_shield_energy: float, cur_max_shield_energy: float) -> void:
	shield_progress_bar.max_value = cur_max_shield_energy
	shield_progress_bar.value = cur_shield_energy
	var percent := remap(cur_max_shield_energy, 10.0, 100.0, 10.0, 100.0)
	shield_progress_bar.custom_minimum_size.x = 640 * (percent / 100)


func _set_player_hull_plating(player_hull_plating: int) -> void:
	if player_hull_plating > 0:
		hull_plating_1.visible = true
	else:
		hull_plating_1.visible = false
		
	if player_hull_plating > 1:
		hull_plating_2.visible = true
	else:
		hull_plating_2.visible = false
		
	if player_hull_plating > 2:
		hull_plating_3.visible = true
	else:
		hull_plating_3.visible = false


func show_new_wave_message(wave_number: int) -> void:
	var new_message := "WAVE " + str(wave_number) + "\rINCOMING"
	new_wave_label.text = new_message
	new_wave_label.self_modulate = Color.WHITE
	new_wave_label.show()
	
	if new_wave_label_tween:
		new_wave_label_tween.kill()
	
	new_wave_label_tween = create_tween()
	new_wave_label_tween.tween_property(new_wave_label, "self_modulate", Color(1.0, 1.0, 1.0, 0.0), 2.0)
