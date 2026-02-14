extends Node2D
class_name MuzzleFlash

@export var flash_color := Color.from_string("f95738", Color.WHITE)

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	gpu_particles_2d.process_material.color = flash_color * 4.0

func emit_flash() -> void:
	gpu_particles_2d.emitting = true
