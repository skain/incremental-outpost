extends Area2D
class_name Cannon

enum CannonStates { READY_TO_FIRE, RECHARGING, DESTROYED }

signal cannon_hit(cannon_direction: Vector2)

const PROJECTILE_SCENE = preload("res://scenes/arcade/player_projectile/player_projectile.tscn")

@onready var cannon: Sprite2D = %Cannon
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var fire_audio_player: AudioStreamPlayer2D = $FireAudioPlayer
@onready var hit_audio_player: AudioStreamPlayer2D = $HitAudioPlayer
@onready var muzzle_flash: MuzzleFlash = $MuzzleFlash
@onready var radial_cooldown: RadialCooldown = %RadialCooldown
@onready var autofire_line_2d: Line2D = %AutofireLine2D

@export var fire_cooldown_base: float = 10.0

var fire_direction: Vector2
var cur_state := CannonStates.READY_TO_FIRE
var _autofire_enabled := false

func _ready() -> void:
	fire_direction = _get_fire_direction()
	_setup_autofire()
	if rotation_degrees == 90.0 or rotation_degrees == 180.0:
		radial_cooldown.position.x *= -1.0


func _setup_autofire() -> void:
	match rotation_degrees:
		0.0:
			_autofire_enabled = GameManager.skills_manager.get_top_cannon_autofire_enabled()
		90.0:
			_autofire_enabled = GameManager.skills_manager.get_right_cannon_autofire_enabled()
		180.0:
			_autofire_enabled = GameManager.skills_manager.get_bottom_cannon_autofire_enabled()
		270.0:
			_autofire_enabled = GameManager.skills_manager.get_left_cannon_autofire_enabled()
		_:
			print("Error: " + name + " has unrecognized rotation: ", rotation_degrees)
	autofire_ray_cast_2d.enabled = _autofire_enabled
	autofire_line_2d.visible = _autofire_enabled

func _set_fire_cooldown() -> void:
	var cooldown := GameManager.skills_manager.get_cannon_cooldown()
	radial_cooldown.cooldown_duration = cooldown
	
	
func _handle_hit() -> void:		
	collision_shape_2d.set_deferred("disabled", true)
	cannon.frame = 1
	cur_state = CannonStates.DESTROYED
	cannon_hit.emit(fire_direction)
	hit_audio_player.play()
	_hit_flash()
	
	
func _hit_flash() -> void:
	var tween := create_tween()
	add_flash_to_tween(tween)
	
func _get_fire_direction() -> Vector2:
	return -global_transform.y
	
	
func fire_projectile(projectile_owner: Node) -> void:
	if not cur_state == CannonStates.READY_TO_FIRE:
		return
		
	var projectile: PlayerProjectile = PROJECTILE_SCENE.instantiate()
	projectile_owner.add_child(projectile)
	projectile.global_position =  global_position
	projectile.setup(fire_direction)
	fire_audio_player.play()
	muzzle_flash.emit_flash()

	cur_state = CannonStates.RECHARGING
	radial_cooldown.start_cooldown()	


func add_flash_to_tween(tween: Tween) -> void:
	HitFlashHelper.add_hit_flash_to_tween(tween, cannon)
	
	
func reset() -> void:
	cannon.frame = 0
	cur_state = CannonStates.READY_TO_FIRE
	collision_shape_2d.set_deferred("disabled", false)
	_set_fire_cooldown()
	
	
func disable() -> void:
	cur_state = CannonStates.DESTROYED


func _on_area_entered(area: Area2D) -> void:
	var projectile := area as EnemyProjectile
	if projectile:
		projectile.handle_hit()
		
	_handle_hit()	


func _on_radial_cooldown_cooldown_complete() -> void:
	if cur_state == CannonStates.RECHARGING:
		cur_state = CannonStates.READY_TO_FIRE
