class_name RepairDroneSprite extends Sprite2D


@export var phase1_duration := 0.4
@export var phase2_duration := 0.5
@export var mid_position_y := 120.0

func zoom(from: Vector2, to: Vector2) -> void:
	global_position = from
	var mid_position := from + Vector2.DOWN * mid_position_y
	
	var tween := create_tween()
	
	# --- PHASE 1 ---
	tween.parallel().tween_property(self, "global_position", mid_position, phase1_duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(self, "scale", Vector2(1.25, 1.25), phase1_duration).set_ease(Tween.EASE_OUT)
	
	# --- PHASE 2 ---
	tween.chain().tween_property(self, "global_position", to, phase2_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(self, "scale", Vector2(0.25, 0.25), phase2_duration).set_ease(Tween.EASE_IN)
	
	tween.chain().tween_callback(queue_free)
