class_name ShieldsManager extends Node2D

@onready var top_shield: Shield = $TopShield
@onready var right_shield: Shield = $RightShield
@onready var bottom_shield: Shield = $BottomShield
@onready var left_shield: Shield = $LeftShield
@onready var shield_timeout_timer: Timer = %ShieldTimeoutTimer

var active_inputs: Array[String] = []
var shields_enabled := false
var shields_active := false
var cur_shield_energy_max: float
var cur_shield_energy: float
var is_shield_on := false
var cur_shield_drain_rate: float
var cur_shield_charge_rate: float
var is_shield_charge_available := true
var multi_shield_enabled := false
var active_shield_count := 0

# Cache the actions for performance
const ACTIONS = ["shield_up", "shield_down", "shield_left", "shield_right"]

func _ready() -> void:
	for s: Shield in find_children("*", "Shield", false, false):
		s.autoshield_engaged.connect(_on_autoshield_engaged)
		s.autoshield_disengaged.connect(_on_autoshield_disengaged)


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
	shields_enabled = GameManager.skills_manager.get_shields_enabled()
	cur_shield_energy_max = GameManager.skills_manager.get_shield_max_energy()
	cur_shield_charge_rate = GameManager.skills_manager.get_shield_charge_rate()
	cur_shield_drain_rate = GameManager.skills_manager.get_shield_drain_rate()
	shield_timeout_timer.wait_time = GameManager.skills_manager.get_shield_timeout()
	multi_shield_enabled = GameManager.skills_manager.get_multishield_enabled()
	
	if shields_enabled:
		cur_shield_energy = cur_shield_energy_max
		SignalBus.shield_energy_updated.emit(cur_shield_energy, cur_shield_energy_max)


func _process(delta: float) -> void:
	var new_shield_energy := cur_shield_energy
	var energy_changed := false

	if is_shield_on and active_shield_count > 0:
		if cur_shield_energy > 0.0:
			# Use the counter for scaling drain
			var total_drain := cur_shield_drain_rate * active_shield_count
			new_shield_energy = cur_shield_energy - (total_drain * delta)
			energy_changed = true
	else:
		# Recharge logic
		if is_shield_charge_available and cur_shield_energy < cur_shield_energy_max:
			new_shield_energy = cur_shield_energy + (cur_shield_charge_rate * delta)
			energy_changed = true

	if energy_changed:
		cur_shield_energy = clamp(new_shield_energy, 0, cur_shield_energy_max)
		SignalBus.shield_energy_updated.emit(cur_shield_energy, cur_shield_energy_max)

	if is_shield_on and cur_shield_energy <= 0.0:
		_shut_down_shields()
		is_shield_charge_available = false
		shield_timeout_timer.start()
	
	if not is_shield_charge_available:
		SignalBus.shield_cooldown_updated.emit(shield_timeout_timer.wait_time, shield_timeout_timer.time_left)


func _shut_down_shields() -> void:
	is_shield_on = false
	top_shield.shield_off()
	right_shield.shield_off()
	bottom_shield.shield_off()
	left_shield.shield_off()


func _apply_shield_logic() -> void:
	if not shields_enabled:
		return
	
	_shut_down_shields()
	
	if cur_shield_energy <= 0.0:
		return

	# If powerup is NOT owned, keep original behavior (only one shield)
	if not multi_shield_enabled:
		if not active_inputs.is_empty():
			_activate_shield(active_inputs.back().replace("shield_", ""))
	else:
		# Multi-shield: activate all in the stack
		for input in active_inputs:
			_activate_shield(input.replace("shield_", ""))


func _activate_shield(direction: String) -> void:
	match direction:
		"up": top_shield.shield_on()
		"right": right_shield.shield_on()
		"down": bottom_shield.shield_on()
		"left": left_shield.shield_on()
	is_shield_on = true

# signal handlers
func _on_shield_timeout_timer_timeout() -> void:
	is_shield_charge_available = true
	SignalBus.shield_cooldown_updated.emit(shield_timeout_timer.wait_time, 0)


func _on_autoshield_engaged() -> void:
	active_shield_count += 1
	is_shield_on = true


func _on_autoshield_disengaged() -> void:
	active_shield_count = max(0, active_shield_count - 1)
	if active_shield_count == 0:
		is_shield_on = false
