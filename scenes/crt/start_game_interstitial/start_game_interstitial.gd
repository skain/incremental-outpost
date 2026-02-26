class_name StartGameInterstitial extends CanvasLayer

signal new_game_clicked
signal load_game_clicked

@export var pulse_max := 1.25
@export var pulse_min := 0.85
@export var pulse_speed := 1.0

@onready var title_label: Label = %TitleLabel

var pulse_tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_pulse_title()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _pulse_title() -> void:
	title_label.self_modulate = Color.WHITE * pulse_min
	pulse_tween = get_tree().create_tween().set_loops()
	pulse_tween.tween_property(title_label, "self_modulate", Color.WHITE * pulse_max, pulse_speed)
	pulse_tween.tween_property(title_label, "self_modulate", Color.WHITE * pulse_min, pulse_speed)


func _on_new_game_button_pressed() -> void:
	print("new game pressed")


func _on_continue_button_pressed() -> void:
	print("continue pressed")
