extends Area2D
class_name Cannon

signal cannon_hit(cannon_direction: Vector2)

const PROJECTILE_SCENE = preload("res://scenes/arcade/player_projectile/player_projectile.tscn")

@onready var cannon: Sprite2D = %Cannon
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var fire_audio_player: AudioStreamPlayer2D = $FireAudioPlayer
@onready var hit_audio_player: AudioStreamPlayer2D = $HitAudioPlayer
@onready var muzzle_flash: MuzzleFlash = $MuzzleFlash
@onready var radial_cooldown: RadialCooldown = %RadialCooldown

@export var fire_cooldown_base: float = 10.0

var fire_direction: Vector2
var can_fire := true

func _ready() -> void:
	fire_direction = _get_fire_direction()
	radial_cooldown.cooldown_duration = _calculate_fire_cooldown()
	if rotation_degrees == 90.0 or rotation_degrees == 180.0:
		radial_cooldown.position.x *= -1.0


func _calculate_fire_cooldown() -> float:
	var mod := GameManager.get_cannon_cooldown_modifier()
	if mod == 0.0:
		mod = 1.0
	var cooldown: float = mod * fire_cooldown_base
	return cooldown
	
func _handle_hit() -> void:		
	collision_shape_2d.set_deferred("disabled", true)
	cannon.frame = 1
	can_fire = false
	cannon_hit.emit(fire_direction)
	hit_audio_player.play()
	_hit_flash()
	
	
func _hit_flash() -> void:
	var tween := create_tween()
	add_flash_to_tween(tween)
	
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
	radial_cooldown.start_cooldown()	


func add_flash_to_tween(tween: Tween) -> void:
	HitFlashHelper.add_hit_flash_to_tween(tween, cannon)
	
	
func reset() -> void:
	cannon.frame = 0
	can_fire = true
	collision_shape_2d.set_deferred("disabled", false)
	
	
func disable() -> void:
	can_fire = false


func _on_area_entered(area: Area2D) -> void:
	var projectile := area as EnemyProjectile
	if projectile:
		projectile.handle_hit()
		
	_handle_hit()	


func _on_radial_cooldown_cooldown_complete() -> void:
	can_fire = true
