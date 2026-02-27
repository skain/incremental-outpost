class_name HitFlashHelper extends Node

# Assumes that the hit_flash.gdshader is already applied as a material to the Sprite2D
static func add_hit_flash_to_tween(tween: Tween, sprite2d: Sprite2D) -> void:
	assert(sprite2d.material)
		
	sprite2d.material.set_shader_parameter("flash_modifier", 1.0)
	tween.tween_property(sprite2d.material, "shader_parameter/flash_modifier", 0.0, 0.15)
