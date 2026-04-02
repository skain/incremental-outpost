class_name PoofLabel extends Label

@export var travel_distance: Vector2 = Vector2(0, -80)
@export var duration: float = 0.8
@export var spread: float = 0.0

func start(value: String, start_pos: Vector2) -> void:
	text = value
	global_position = start_pos
	
	# Randomize direction slightly for a "fountain" effect
	var move_direction := travel_distance.rotated(deg_to_rad(randf_range(-spread, spread)))
	
	# Create the tween
	var tween := create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# 1. Animate Position
	tween.tween_property(self, "global_position", global_position + (move_direction / 2.0), duration)
	
	# 2. Animate Scale (Scale down to 0)
	tween.tween_property(self, "scale", Vector2.ZERO, duration)
	
	# 3. Animate Alpha (Fade out)
	tween.tween_property(self, "modulate:a", 0.0, duration)
	
	# Cleanup: Delete the node when the tween finishes
	tween.chain().finished.connect(queue_free)
