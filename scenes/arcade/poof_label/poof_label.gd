class_name PoofLabel extends Label

@export var travel_distance: Vector2 = Vector2(0, -80)
@export var phase1_duration: float = 0.3
@export var phase2_duration: float = 0.5
@export var spread: float = 15.0


func start(value: String, start_pos: Vector2, target_global_pos: Vector2) -> void:
	text = value
	global_position = start_pos
	
	# Phase 1 target: Uses travel_distance (halfway to center) with spread
	var move_direction := travel_distance.rotated(deg_to_rad(randf_range(-spread, spread)))
	var phase1_target_pos := global_position + move_direction
	
	var total_duration := phase1_duration + phase2_duration
	var tween := create_tween()
	
	# --- PHASE 1: Pop halfway toward the center ---
	tween.parallel().tween_property(self, "global_position", phase1_target_pos, phase1_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# --- PHASE 2: Fly to Score Target ---
	tween.chain().tween_property(self, "global_position", target_global_pos, phase2_duration)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# --- OVERALL: Fade and Scale over entire duration ---
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, total_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "modulate:a", 0.0, total_duration)\
		.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	# Cleanup node when all tweens complete
	tween.chain().tween_callback(queue_free)
