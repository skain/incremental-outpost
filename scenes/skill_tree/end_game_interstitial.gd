class_name EndGameInterstitial extends CanvasLayer

@export var character_reveal_speed: float = .25

@onready var message_1: Label = %Message1
@onready var message_2: Label = %Message2
@onready var conversion_message: Label = %ConversionMessage
@onready var bucks_conversion_display: Label = %BucksConversionDisplay
@onready var conversion_success_message: Label = %ConversionSuccessMessage
@onready var message_3: Label = %Message3
@onready var conversion_success_message_2: Label = %ConversionSuccessMessage2
@onready var interstitial_message_timer: Timer = %InterstitialMessageTimer
@onready var interstitial_labels_container: VBoxContainer = %InterstitialLabelsContainer

func _ready() -> void:
	_reset_messages()
	run_interstitial(100, 0.1)
	
func _reset_messages() -> void:
	message_1.visible_ratio = 0
	message_2.visible_ratio = 0
	conversion_message.visible_ratio = 0
	bucks_conversion_display.visible_ratio = 0
	conversion_success_message.visible_ratio = 0
	message_3.visible_ratio = 0
	conversion_success_message_2.visible_ratio = 0
	bucks_conversion_display.text = "B: 0"
	
func run_interstitial(points: int, bucks_per_point: float) -> int:
	var new_bucks := GameMath.convert_points_to_bucks(points, bucks_per_point)
	conversion_message.text = conversion_message.text.replace("%points%", str(points)).replace("%bucks_per%", str(bucks_per_point))
	conversion_success_message.text = conversion_success_message.text.replace("%points%", str(points)).replace("%bucks%", str(new_bucks))
	
	await reveal_label(message_1)
	await reveal_label(message_2)
	await reveal_label(conversion_message)
	await reveal_label(bucks_conversion_display)
	await count_up_bucks(new_bucks)
	await reveal_label(conversion_success_message)
	await reveal_label(message_3)
	await reveal_label(conversion_success_message_2)
	
	
	
	return new_bucks
	
func reveal_label(label: Label) -> void:
	print("revealing: " + label.name)
	var time_to_reveal := character_reveal_speed * label.text.length()
	var tween := create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, time_to_reveal)
	await tween.finished
	
func count_up_bucks(target_amount: float) -> void:
	var duration := target_amount * (character_reveal_speed / 2)
	
	var tween := create_tween()

	# We "tween" a method. 
	# It sends values from 0 to target_amount into the helper function below.
	tween.tween_method(
		func(value: float) -> void: bucks_conversion_display.text = "B: " + str(snapped(value, 0.01)), 
		0.0, 
		target_amount, 
		duration
	)

	await tween.finished
