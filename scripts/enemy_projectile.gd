extends Area2D
class_name EnemyProjectile

@export var speed: float = 400
@export var projectile_collision_sound: AudioStream

@onready var hit_player: AudioStreamPlayer2D = $HitPlayer

var direction: Vector2
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * delta

func setup(starting_direction: Vector2) -> void:
	direction = starting_direction.normalized()
	velocity = direction * speed
	
func handle_hit() -> void:
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
	Sfx.play_sfx(projectile_collision_sound, global_position)
	queue_free()
