extends Area2D
class_name PlayerProjectile

@export var speed: float = 400

var direction: Vector2
var velocity: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta
	var viewport_size := get_viewport_rect().size
	if position.x < 0 or position.y < 0 or position.x > viewport_size.x or position.y > viewport_size.y:
		print('projectile destroyed')
		queue_free()

func setup(starting_direction: Vector2):
	direction = starting_direction.normalized()
	velocity = direction * speed
