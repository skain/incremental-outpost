class_name VolumeControl extends HBoxContainer

@export var bus_name := "Master"

@onready var volume_label: Label = %VolumeLabel
@onready var volume_h_slider: HSlider = %VolumeHSlider
@onready var enabled_check_box: CheckBox = %EnabledCheckBox

var bus_index: int

func _ready() -> void:
	# 1. Get the index for the named bus
	bus_index = AudioServer.get_bus_index(bus_name)

	# 2. Set the Label text to the bus name
	volume_label.text = bus_name

	# 3. Initialize the slider, checkbox, and the bus itself from the saved game data
	var volume_db := GameManager.game_data.bus_volumes[bus_name]
	_set_volume(volume_db)
	volume_h_slider.value = db_to_linear(volume_db)
	
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
