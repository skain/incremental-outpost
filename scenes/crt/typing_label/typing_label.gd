class_name TypingLabel extends Label

signal typing_complete

@export var chars_per_second: float = 5
@export var typing_sound: AudioStream

@onready var timer: Timer = %Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_ratio = 0
	#_test()
	#
#func _test() -> void:
	#start_typing()
	#await typing_complete
	#print("complete")

func _get_wait_time() -> float:
	return 1.0 / chars_per_second
	
func _type_character() -> void:
	if visible_ratio < 1:
		visible_characters += 1
	var last_char := text[visible_characters - 1]

	# 1. Pitch Randomization
	if typing_sound:
		# Assuming your Sfx singleton can take a pitch_scale parameter
		# If not, you can adjust the pitch of the AudioStreamPlayer directly
		#var pitch = randf_range(0.9, 1.1) 
		#Sfx.play_sfx(typing_sound, global_position, pitch)
		Sfx.play_sfx(typing_sound, global_position)

	# 2. Dynamic Timing Logic
	var next_delay := _get_wait_time()

	# Add a "thinking" pause for punctuation
	if last_char == "." or last_char == "!" or last_char == "?":
		next_delay *= 8.0  # Big pause at end of sentences
	elif last_char == "," or last_char == ";" or last_char == ":":
		next_delay *= 4.0  # Medium pause for breath
	elif last_char == " ":
		next_delay *= 1.5  # Slight pause between words

	# 3. Micro-randomization (the "Human" factor)
	next_delay += randf_range(-0.01, 0.01)

	# Restart the timer with the new custom delay
	timer.start(max(0.01, next_delay))

	if visible_ratio == 1:
		finish_typing()
			
	
	if visible_ratio == 1:
		finish_typing()
	
func start_typing() -> void:
	timer.wait_time = _get_wait_time()
	timer.start()
	await typing_complete
	
func finish_typing() -> void:
	timer.stop()
	visible_ratio = 1
	typing_complete.emit()
	
func reset() -> void:
	timer.stop()
	visible_ratio = 0

func _on_timer_timeout() -> void:
	_type_character()
