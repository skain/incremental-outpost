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
@onready var crt_shader: ColorRect = %CRTShader
@onready var crt_shader_mat: ShaderMaterial = %CRTShader.material

func _ready() -> void:
	_screen_off()
	_reset_messages()
	
func _test_screen() -> void:
	await _power_up()
	await run_interstitial(100, 0.1)
	await get_tree().create_timer(2.0).timeout
	await _power_down()
	
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
	
	await _reveal_label(message_1)
	await _reveal_label(message_2)
	await _reveal_label(conversion_message)
	await _reveal_label(bucks_conversion_display)
	await _count_up_bucks(new_bucks)
	await _reveal_label(conversion_success_message)
	await _reveal_label(message_3)
	await _reveal_label(conversion_success_message_2)
	
	
	
	return new_bucks
	
func _reveal_label(label: Label) -> void:
	print("revealing: " + label.name)
	var time_to_reveal := character_reveal_speed * label.text.length()
	var tween := create_tween()
	tween.tween_property(label, "visible_ratio", 1.0, time_to_reveal)
	await tween.finished
	
func _count_up_bucks(target_amount: float) -> void:
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
	
func _power_up() -> void:
	await _animate_power(0.0, 1.0)
	## Create a Tween to animate it turning on
	#var tween := create_tween()
#
	## We use tween_property with the "shader_parameter/" prefix.
	## .from(0.0) forces it to start completely black every time!
	#await tween.tween_property(
		#crt_shader_mat, 
		#"shader_parameter/power_on", 
		#1.0, 
		#0.75
	#).from(0.0).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	#
	## add a small delay before the screen is ready
	#await get_tree().create_timer(1.5).timeout
	
func _power_down() -> void:
	await _animate_power(1.0, 0.0)
	
func _animate_power(from: float, to: float) -> void:
	# Create a Tween to animate it turning on
	var tween := create_tween()

	# We use tween_property with the "shader_parameter/" prefix.
	# .from(0.0) forces it to start completely black every time!
	tween.tween_property(
		crt_shader_mat, 
		"shader_parameter/power_on", 
		to, 
		0.75
	).from(from).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	
func _screen_off() -> void:
	crt_shader_mat.set_shader_parameter("power_on", 0.0)
