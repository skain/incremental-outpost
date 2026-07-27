class_name ShieldsManager extends Node2D

@onready var top_shield: Shield = $TopShield
@onready var right_shield: Shield = $RightShield
@onready var bottom_shield: Shield = $BottomShield
@onready var left_shield: Shield = $LeftShield
@onready var shield_timeout_timer: Timer = %ShieldTimeoutTimer

var active_inputs: Array[String] = []
var shields_enabled := false
var cur_shield_energy_max: float
var cur_shield_energy: float
var cur_shield_drain_rate: float
var cur_shield_charge_rate: float
var is_shield_charge_available := true
var multi_shield_enabled := false

@onready var all_shields: Array[Shield] = [top_shield, right_shield, bottom_shield, left_shield]

const ACTIONS = ["shield_up", "shield_down", "shield_left", "shield_right"]


func _ready() -> void:
	for s: Shield in all_shields:
		s.autoshield_engaged.connect(_on_autoshield_changed)
		s.autoshield_disengaged.connect(_on_autoshield_changed)


func _input(event: InputEvent) -> void:
	var is_shield_action := false
	for action: String in ACTIONS:
		if event.is_action(action):
			is_shield_action = true
			break
	
	if not is_shield_action:
		return

	for action: String in ACTIONS:
		if event.is_action_pressed(action):
			if not active_inputs.has(action):
				active_inputs.append(action)
				_apply_shield_logic()
			break
		elif event.is_action_released(action):
			active_inputs.erase(action)
			_apply_shield_logic()
			break


func reset() -> void:
	shields_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.SHIELDS_ENABLED)
	cur_shield_energy_max = SkillsManager.get_as_float(SkillTreeNode.AffectedStat.SHIELD_MAX_ENERGY)
	cur_shield_charge_rate = SkillsManager.get_as_float(SkillTreeNode.AffectedStat.SHIELD_CHARGE_RATE)
	cur_shield_drain_rate = SkillsManager.get_as_float(SkillTreeNode.AffectedStat.SHIELD_DRAIN_RATE)
	shield_timeout_timer.wait_time = SkillsManager.get_as_float(SkillTreeNode.AffectedStat.SHIELD_TIMEOUT)
	multi_shield_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.MULTISHIELD_ENABLED)
	
	if shields_enabled:
		cur_shield_energy = cur_shield_energy_max
		SignalBus.shield_energy_updated.emit(cur_shield_energy, cur_shield_energy_max)


func _process(delta: float) -> void:
	var active_count := _get_active_shield_count()
	var is_shield_on := active_count > 0
	var new_shield_energy := cur_shield_energy
	var energy_changed := false

	if is_shield_on:
		if cur_shield_energy > 0.0:
			# Drain scales dynamically based on total active shields across input and autoshields
			var total_drain := cur_shield_drain_rate * active_count
			new_shield_energy = cur_shield_energy - (total_drain * delta)
			energy_changed = true
	else:
		# Recharge when zero shields are active and recharge is available
		if is_shield_charge_available and cur_shield_energy < cur_shield_energy_max:
			new_shield_energy = cur_shield_energy + (cur_shield_charge_rate * delta)
			energy_changed = true

	if energy_changed:
		cur_shield_energy = clamp(new_shield_energy, 0.0, cur_shield_energy_max)
		SignalBus.shield_energy_updated.emit(cur_shield_energy, cur_shield_energy_max)

	# Shut down player-held shields on depletion without forcing autoshields off completely
	if is_shield_on and cur_shield_energy <= 0.0:
		_shut_down_manual_shields()
		is_shield_charge_available = false
		shield_timeout_timer.start()
	
	if not is_shield_charge_available:
		SignalBus.shield_cooldown_updated.emit(shield_timeout_timer.wait_time, shield_timeout_timer.time_left)


## Queries the child shield nodes directly to determine total active shields.
func _get_active_shield_count() -> int:
	var count := 0
	for s in all_shields:
		if s.is_active:
			count += 1
	return count


## Clears player-driven shield states across all shields.
func _shut_down_manual_shields() -> void:
	for s in all_shields:
		s.clear_manual_activation()


func _apply_shield_logic() -> void:
	if not shields_enabled:
		return
	
	_shut_down_manual_shields()
	
	if cur_shield_energy <= 0.0:
		return

	if not multi_shield_enabled:
		if not active_inputs.is_empty():
			_activate_shield(active_inputs.back().replace("shield_", ""))
	else:
		for input in active_inputs:
			_activate_shield(input.replace("shield_", ""))


func _activate_shield(direction: String) -> void:
	match direction:
		"up": top_shield.shield_on(false)
		"right": right_shield.shield_on(false)
		"down": bottom_shield.shield_on(false)
		"left": left_shield.shield_on(false)


# Handlers to hook UI/audio updates on autoshield state changes if needed
func _on_autoshield_changed() -> void:
	pass


func _on_shield_timeout_timer_timeout() -> void:
	is_shield_charge_available = true
	SignalBus.shield_cooldown_updated.emit(shield_timeout_timer.wait_time, 0)
