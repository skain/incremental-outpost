class_name ShieldsComponent extends Node

signal shield_changed(new_direction: String)

var current_shield_direction := "" :
	set(value):
		if current_shield_direction != value:
			current_shield_direction = value
			shield_changed.emit(value) # Only fire when it actually changes
			
var active_inputs: Array[String] = []

# Cache the actions for performance
const ACTIONS = ["shield_up", "shield_down", "shield_left", "shield_right"]

func _input(event: InputEvent) -> void:
	# Quick exit: if the event isn't a shield action, don't loop
	var is_shield_action := false
	for action: String in ACTIONS:
		if event.is_action(action):
			is_shield_action = true
			break
	
	if not is_shield_action:
		return

	# Process the stack
	for action: String in ACTIONS:
		if event.is_action_pressed(action):
			if not active_inputs.has(action):
				active_inputs.append(action)
				_apply_shield_logic()
			# break once we find the action to save cycles
			break 
			
		elif event.is_action_released(action):
			active_inputs.erase(action)
			_apply_shield_logic()
			break

func _apply_shield_logic() -> void:
	if active_inputs.is_empty():
		current_shield_direction = ""
	else:
		current_shield_direction = active_inputs.back().replace("shield_", "")
