class_name RadialCooldown extends TextureProgressBar

signal cooldown_complete

@export var cooldown_duration: float

@onready var cooldown_timer: Timer = %CooldownTimer

var normalized_percent_duration_left: float :
	get:
		return cooldown_timer.time_left / cooldown_timer.wait_time


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotation = get_parent().rotation * -1
	visible = false


func _process(_delta: float) -> void:
	value = cooldown_timer.time_left


func start_cooldown() -> void:
	assert(cooldown_duration > 0)
	max_value = cooldown_duration
	value = 0.0
	visible = true
	cooldown_timer.start(cooldown_duration)

func is_on_cooldown() -> bool:
	return not cooldown_timer.is_stopped()


func set_autostart(val: bool) -> void:
	cooldown_timer.autostart = val


func set_one_shot(val: bool) -> void:
	cooldown_timer.one_shot = val


func _on_cooldown_timer_timeout() -> void:
	visible = false
	cooldown_complete.emit()
