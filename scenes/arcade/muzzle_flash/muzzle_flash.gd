extends Node2D
class_name MuzzleFlash

@export var flash_color := Color.from_string("f95738", Color.WHITE)

@onready var cpu_particles_2d: CPUParticles2D = %CPUParticles2D

func _ready() -> void:
	cpu_particles_2d.color = flash_color

func emit_flash() -> void:
	cpu_particles_2d.emitting = true
