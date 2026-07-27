class_name PoofLabel extends Label

signal arrived

@export var travel_distance: Vector2 = Vector2(0, -80)
@export var phase1_duration: float = 0.2
@export var phase2_duration: float = 0.25
@export var finish_early_modifier: float = 0.8
@export var spread: float = 15.0


func start(value: String, start_pos: Vector2, target_global_pos: Vector2) -> void:
	text = value
	global_position = start_pos
	
	var move_direction := travel_distance.rotated(deg_to_rad(randf_range(-spread, spread)))
	var phase1_target_pos := global_position + move_direction
	var total_duration := phase1_duration + phase2_duration
	
	var tween := create_tween()
	
	# --- PHASE 1 ---
	tween.parallel().tween_property(self, "global_position", phase1_target_pos, phase1_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# --- PHASE 2 ---
	tween.chain().tween_property(self, "global_position", target_global_pos, phase2_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# Trigger arrival IMMEDIATELY when movement finishes (don't wait for fadeout/cleanup)
	tween.chain().tween_callback(arrived.emit)
	
	# --- OVERALL FADE/SCALE ---
	tween.parallel().tween_property(self, "scale", Vector2.ZERO, total_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "modulate:a", 0.0, total_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
	
	tween.chain().tween_callback(queue_free)
