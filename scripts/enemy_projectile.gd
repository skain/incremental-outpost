extends Area2D
class_name EnemyProjectile

@export var speed: float = 400

var direction: Vector2
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	position += velocity * delta

func setup(starting_direction: Vector2):
	direction = starting_direction.normalized()
	velocity = direction * speed
	
