extends Area2D
class_name Cannon

const PROJECTILE_SCENE = preload("res://scenes/player_projectile.tscn")

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var fire_rate: float = 0.2
@export var fire_direction: Vector2 = Vector2.UP

var can_fire := true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _handle_hit() -> void:
	sprite_2d.frame = 1
	can_fire = false
	
func fire_projectile(projectile_owner: Node) -> void:
	if not can_fire:
		return
		
	var projectile: PlayerProjectile = PROJECTILE_SCENE.instantiate()
	projectile_owner.add_child(projectile)
	var start_position := global_position + (fire_direction * 25)
	#print(start_position)
	projectile.global_position =  start_position
	projectile.setup(fire_direction)
	#print("fired")

	can_fire = false  # Prevent further firing
	await get_tree().create_timer(fire_rate).timeout  # Wait for fire_rate seconds
	can_fire = true  # Allow firing again after the delay


func _on_area_entered(area: Area2D) -> void:
	_handle_hit()
