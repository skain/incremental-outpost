class_name RadialCooldown extends TextureProgressBar

signal cooldown_complete

@export var cooldown_duration: float

@onready var cooldown_timer: Timer = %CooldownTimer

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


func _on_cooldown_timer_timeout() -> void:
	visible = false
	cooldown_complete.emit()
