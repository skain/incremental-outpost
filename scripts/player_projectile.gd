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

func setup(starting_direction: Vector2):
	direction = starting_direction.normalized()
	velocity = direction * speed


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	print('projectile destroyed')
	queue_free()
