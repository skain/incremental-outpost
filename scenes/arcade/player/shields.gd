class_name ShieldsManager extends Node2D

signal shield_energy_updated(cur_shield_energy: float)

@onready var top_shield: Shield = $TopShield
@onready var right_shield: Shield = $RightShield
@onready var bottom_shield: Shield = $BottomShield
@onready var left_shield: Shield = $LeftShield

@export var base_shield_energy_max := 10.0
@export var base_shield_drain_rate := 2.0
@export var base_shield_charge_rate := 2.0

var active_inputs: Array[String] = []
var shields_enabled := false
var shields_active := false
var cur_shield_energy_max: float
var cur_shield_energy: float
var is_shield_on := false
var cur_shield_drain_rate: float
var cur_shield_charge_rate: float

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

func reset() -> void:
	shields_enabled = GameManager.get_shields_enabled_modifier()
	cur_shield_energy_max = GameManager.get_shield_max_energy_modifier() * base_shield_energy_max
	cur_shield_charge_rate = base_shield_charge_rate
	cur_shield_drain_rate = base_shield_drain_rate
	if shields_enabled:
		cur_shield_energy = cur_shield_energy_max
		shield_energy_updated.emit(cur_shield_energy)
	


func _process(delta: float) -> void:
	if is_shield_on and cur_shield_energy > 0:
		cur_shield_energy -= cur_shield_drain_rate * delta
	elif cur_shield_energy < cur_shield_energy_max:
		cur_shield_energy += cur_shield_charge_rate * delta
	else:
		return
	
	cur_shield_energy = clamp(cur_shield_energy, 0, cur_shield_energy_max)
	
	shield_energy_updated.emit(cur_shield_energy)

func _apply_shield_logic() -> void:
	is_shield_on = false
	if shields_enabled == false:
		return
	
	var current_shield_direction := ""
	if not active_inputs.is_empty():
		current_shield_direction = active_inputs.back().replace("shield_", "")
	
	top_shield.shield_off()
	right_shield.shield_off()
	bottom_shield.shield_off()
	left_shield.shield_off()
	
	if cur_shield_energy <= 0.0:
		return
	
	match current_shield_direction:
		"up":
			top_shield.shield_on()
			is_shield_on = true
		"right":
			right_shield.shield_on()
			is_shield_on = true
		"down":
			bottom_shield.shield_on()
			is_shield_on = true
		"left":
			left_shield.shield_on()
			is_shield_on = true
