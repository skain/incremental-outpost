class_name ArcadeUI extends CanvasLayer

const SMART_BOMB_UI_ICON : Texture2D = preload("uid://npeeevesdgsd")
const TOTAL_MAX_SHIELD_ENERGY := 300.0

@onready var score_value: Label = %ScoreValue
@onready var hull_plating_1: TextureRect = %HullPlating1
@onready var hull_plating_2: TextureRect = %HullPlating2
@onready var hull_plating_3: TextureRect = %HullPlating3
@onready var new_wave_label: Label = %NewWaveLabel
@onready var shield_energy_h_box_container: HBoxContainer = %ShieldEnergyHBoxContainer
@onready var shield_progress_bar: ProgressBar = %ShieldProgressBar
@onready var shield_cooldown_progress_bar: TextureProgressBar = %ShieldCooldownProgressBar
@onready var smart_bombs_h_box_container: HBoxContainer = %SmartBombsHBoxContainer

var new_wave_label_tween: Tween


func _ready() -> void:
	_connect_signals()
	shield_cooldown_progress_bar.hide()
	var enabled := SkillsManager.get_shields_enabled()
	if enabled:
		shield_energy_h_box_container.show()
	else:
		shield_energy_h_box_container.hide()


func _connect_signals() -> void:
	SignalBus.shield_cooldown_updated.connect(update_shield_cooldown)
	SignalBus.shield_energy_updated.connect(update_shield_energy)
	SignalBus.smart_bombs_updated.connect(update_smart_bombs)


func update_ui(score: int, player_hull_plating: int) -> void:
	score_value.text = str(score)
	_set_player_hull_plating(player_hull_plating)


func update_shield_energy(cur_shield_energy: float, cur_max_shield_energy: float) -> void:
	shield_progress_bar.max_value = cur_max_shield_energy
	shield_progress_bar.value = cur_shield_energy
	var percent := remap(cur_max_shield_energy, 10.0, 100.0, 10.0, 100.0)
	shield_progress_bar.custom_minimum_size.x = 640 * (percent / 100)

func update_shield_cooldown(shield_cooldown_max: float, shield_cooldown_cur_value: float) -> void:
	shield_cooldown_progress_bar.hide()
	if shield_cooldown_cur_value > 0.0:
		shield_cooldown_progress_bar.max_value = shield_cooldown_max
		shield_cooldown_progress_bar.value = shield_cooldown_max - shield_cooldown_cur_value
		shield_cooldown_progress_bar.show()


func update_smart_bombs(smart_bombs_max: int, smart_bombs_left: int) -> void:
	#delete all children
	for c in smart_bombs_h_box_container.get_children():
		c.queue_free()
	#add new texturerects for each bomb
	#modulate used bomb color
	for i in range(smart_bombs_max):
		var t := TextureRect.new()
		t.texture = SMART_BOMB_UI_ICON
		
		if (i + 1) > smart_bombs_left:
			t.modulate = Color(0.471, 0.471, 0.471)
		else:
			pass
		
		smart_bombs_h_box_container.add_child(t)


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
	new_wave_label_tween.tween_property(new_wave_label, "self_modulate:a", 0.0, 2.0)
