extends Area2D
class_name Player

const PROJECTILE_SCENE = preload("res://scenes/player_projectile.tscn")
@export var fire_rate: float = 0.2

var can_fire: bool = true
	
func _process(delta: float) -> void:
	if can_fire:
		if Input.is_action_just_pressed("fire-up"):
			_fire_projectile(Vector2.UP, Vector2(0,-128))
		elif Input.is_action_just_pressed("fire-down"):
			_fire_projectile(Vector2.DOWN, Vector2(0,128))
		elif Input.is_action_just_pressed("fire-left"):
			_fire_projectile(Vector2.LEFT, Vector2(-128,0))
		elif Input.is_action_just_pressed("fire-right"):
			_fire_projectile(Vector2.RIGHT, Vector2(128,0))

func _fire_projectile(direction: Vector2, offset: Vector2) -> void:
	print("player position: ", position)
	var projectile: PlayerProjectile = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile)
	var start_position := global_position + offset
	print(start_position)
	projectile.global_position =  start_position
	projectile.setup(direction)
	print("fired")

	can_fire = false  # Prevent further firing
	await get_tree().create_timer(fire_rate).timeout  # Wait for fire_rate seconds
	can_fire = true  # Allow firing again after the delay


func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
