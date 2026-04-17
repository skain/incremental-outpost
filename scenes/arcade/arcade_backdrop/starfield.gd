extends Node2D

@export var star_count: int = 120
@export var twinkle_speed_min: float = 0.8
@export var twinkle_speed_max: float = 2.5

func _ready() -> void:
	self.position = -(get_viewport_rect().size / 2.0)
	# Seed the random number generator so it feels different every session
	randomize()
	
	var screen_size := get_viewport_rect().size
	
	for i in range(star_count):
		create_star(screen_size)

func create_star(screen_size: Vector2) -> void:
	var star := ColorRect.new()
	star.size = Vector2(1, 1)

	var pos := Vector2(randf() * screen_size.x, randf() * screen_size.y)
	star.position = pos.floor() 

	# Instead of just opacity, we boost the RGB channels
	# 1.0 is standard white. 4.0 will be "Super White" that triggers the glow.
	var glow_intensity := randf_range(1.5, 4.0)

	# Use Color(r, g, b, a). We set RGB to our intensity.
	# Note: We keep Alpha at 1.0 because the "faintness" is now handled 
	# by how much glow/light the pixel emits.
	star.modulate = Color(glow_intensity, glow_intensity, glow_intensity, 1.0)

	add_child(star)

	if randf() > 0.7:
		animate_twinkle(star, glow_intensity)

func animate_twinkle(star: ColorRect, original_glow: float) -> void:
	var tween := create_tween().set_loops()
	var duration := randf_range(twinkle_speed_min, twinkle_speed_max)

	# We tween the modulate property. To make it "twinkle" effectively in HDR, 
	# we fade the glow intensity down to 0 and back up.
	var off_color := Color(0, 0, 0, 1)
	var on_color := Color(original_glow, original_glow, original_glow, 1)

	tween.tween_property(star, "modulate", off_color, duration).set_delay(randf() * 2.0)
	tween.tween_property(star, "modulate", on_color, duration)
