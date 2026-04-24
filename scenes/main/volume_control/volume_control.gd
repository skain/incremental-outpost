class_name VolumeControl extends HBoxContainer

@export var bus_name := "Master"

@onready var volume_label: Label = %VolumeLabel
@onready var volume_h_slider: HSlider = %VolumeHSlider
@onready var enabled_check_box: CheckBox = %EnabledCheckBox

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	volume_label.text = bus_name

	# 1. Get the linear value (e.g., 0.65)
	var volume_linear := GameManager.game_data.bus_volumes[bus_name]
	
	# 2. Set the audio bus (this function converts it to dB for you)
	_set_volume(volume_linear)
	
	# 3. Set the slider directly using the linear value
	volume_h_slider.value = volume_linear 
	
	# Handle Mute/Enabled
	var enabled := GameManager.game_data.bus_enableds[bus_name]
	enabled_check_box.button_pressed = enabled
	_set_mute(not enabled)


func _set_volume(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(value))


func _set_mute(is_muted: bool) -> void:
	AudioServer.set_bus_mute(bus_index, is_muted)


func _on_volume_h_slider_value_changed(value: float) -> void:
	# Convert the 0.0-1.0 slider value back to decibels
	_set_volume(value)
	GameManager.game_data.bus_volumes[bus_name] = value
	GameManager.save_game()


func _on_enabled_checkbox_toggled(is_pressed: bool) -> void:
	_set_mute(not is_pressed)	
	GameManager.game_data.bus_enableds[bus_name] = is_pressed
	GameManager.save_game()
