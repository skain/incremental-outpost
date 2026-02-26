class_name EndGameInterstitial extends CanvasLayer

signal return_to_outpost_clicked
signal upgrade_clicked

var new_bucks := 0

@export var character_reveal_speed: float = .25

@onready var message_1: TypingLabel = %Message1
@onready var conversion_message: TypingLabel = %ConversionMessage
@onready var bucks_conversion_display: TypingLabel = %BucksConversionDisplay
@onready var conversion_success_message: TypingLabel = %ConversionSuccessMessage
@onready var conversion_success_message_2: TypingLabel = %ConversionSuccessMessage2
@onready var interstitial_message_timer: Timer = %InterstitialMessageTimer
@onready var interstitial_labels_container: VBoxContainer = %InterstitialLabelsContainer
#@onready var crt_shader: ColorRect = %CRTShader
#@onready var crt_shader_mat: ShaderMaterial = %CRTShader.material

func _ready() -> void:
	_reset_messages()
	#_test_screen()
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_interrupt_and_finish_typing()

func _interrupt_and_finish_typing() -> void:
		message_1.stop_typing()
		conversion_message.stop_typing()
		bucks_conversion_display.stop_typing()
		_count_up_bucks()
		conversion_success_message.stop_typing()
		conversion_success_message_2.stop_typing()

	
func _reset_messages() -> void:
	message_1.reset()
	conversion_message.reset()
	bucks_conversion_display.reset()
	conversion_success_message.reset()
	conversion_success_message_2.reset()
	bucks_conversion_display.reset()
	
func run_interstitial() -> void:
	var game_data := GameManager.game_data
	var points_to_convert := game_data.current_points
	new_bucks = GameManager.convert_points_to_bucks()
	conversion_message.text = conversion_message.text.replace("%points%", str(points_to_convert)).replace("%bucks_per%", str(GameManager.get_points_to_bucks_rate()))
	conversion_success_message.text = conversion_success_message.text.replace("%points%", str(points_to_convert)).replace("%bucks%", str(new_bucks))
	
	await message_1.start_typing()
	await conversion_message.start_typing()
	await bucks_conversion_display.start_typing()
	await _count_up_bucks()
	await conversion_success_message.start_typing()
	await conversion_success_message_2.start_typing()
		
func _count_up_bucks() -> void:
	bucks_conversion_display.visible_characters = -1
	if new_bucks < 1:
		return
	
	var duration := new_bucks * (character_reveal_speed / 2)
	
	var tween := create_tween()

	# We "tween" a method. 
	# It sends values from 0 to target_amount into the helper function below.
	tween.tween_method(
		func(value: float) -> void: bucks_conversion_display.text = "B: " + str(snapped(value, 1.0)), 
		0.0, 
		new_bucks, 
		duration
	)

	await tween.finished
	new_bucks = 0
	
#func _power_up() -> void:
	#await _animate_power(0.0, 1.0)
	#
#func _power_down() -> void:
	#await _animate_power(1.0, 0.0)
	#
#func _animate_power(from: float, to: float) -> void:
	## Create a Tween to animate it turning on
	#var tween := create_tween()
#
	## We use tween_property with the "shader_parameter/" prefix.
	## .from(0.0) forces it to start completely black every time!
	#tween.tween_property(
		#crt_shader_mat, 
		#"shader_parameter/power_on", 
		#to, 
		#0.75
	#).from(from).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
	#
	#await tween.finished
	#
#func _screen_off() -> void:
	#crt_shader_mat.set_shader_parameter("power_on", 0.0)

func _on_upgrade_button_pressed() -> void:
	upgrade_clicked.emit()

func _on_return_button_pressed() -> void:
	return_to_outpost_clicked.emit()
