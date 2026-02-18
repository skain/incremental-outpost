extends Area2D
class_name Cannon

signal cannon_hit(cannon_direction: Vector2)

const PROJECTILE_SCENE = preload("res://scenes/player_projectile/player_projectile.tscn")

@onready var sprite_2d: Sprite2D = $Cannon
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var fire_audio_player: AudioStreamPlayer2D = $FireAudioPlayer
@onready var hit_audio_player: AudioStreamPlayer2D = $HitAudioPlayer
@onready var muzzle_flash: MuzzleFlash = $MuzzleFlash

@export var fire_rate: float = 0.2

var fire_direction: Vector2
var can_fire := true

func _ready() -> void:
	fire_direction = _get_fire_direction()
	
func _handle_hit() -> void:
	if not can_fire:
		return
		
	collision_shape_2d.set_deferred("disabled", true)
	sprite_2d.frame = 1
	can_fire = false
	cannon_hit.emit(fire_direction)
	hit_audio_player.play()
	
func _get_fire_direction() -> Vector2:
	return -global_transform.y
	
func fire_projectile(projectile_owner: Node) -> void:
	if not can_fire:
		return
		
	var projectile: PlayerProjectile = PROJECTILE_SCENE.instantiate()
	projectile_owner.add_child(projectile)
	projectile.global_position =  global_position
	projectile.setup(fire_direction)
	fire_audio_player.play()
	muzzle_flash.emit_flash()

	can_fire = false  # Prevent further firing
	await get_tree().create_timer(fire_rate).timeout  # Wait for fire_rate seconds
	can_fire = true  # Allow firing again after the delay

func reset() -> void:
	sprite_2d.frame = 0
	can_fire = true
	collision_shape_2d.set_deferred("disabled", false)

func _on_area_entered(area: Area2D) -> void:
	var projectile := area as EnemyProjectile
	if projectile:
		projectile.handle_hit()
		
	_handle_hit()
	
