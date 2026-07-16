class_name QuantumTeslaCannon extends Sprite2D

@export var player: Node2D

@export var radius: float = 200.0
@export var speed: float = 2.0

@onready var cpu_particles_2d: CPUParticles2D = $CPUParticles2D

var angle: float = 0.0

func _ready() -> void:
	cpu_particles_2d.emitting = true

func _process(delta: float) -> void:
	# Safety check: Ensure the player node exists before trying to access it
	if not is_instance_valid(player):
		return
		
	angle += speed * delta
	angle = wrapf(angle, 0.0, TAU)
	
	var offset: Vector2 = Vector2(cos(angle), sin(angle)) * radius
	
	# Orbit perfectly around the player's current world position
	global_position = player.global_position + offset
