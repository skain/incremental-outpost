extends Area2D
class_name Enemy

signal enemy_hit(enemy:Enemy)

const PROJECTILE_SCENE = preload("res://scenes/arcade/enemy_projectile/enemy_projectile.tscn")

@export var base_shoot_delay: float = 1
@export var base_shoot_chance: float = 50
@export var base_revive_delay: float = 5

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var revive_timer: Timer = $ReviveTimer
@onready var shoot_timer: Timer = $ShootTimer
@onready var shoot_player: AudioStreamPlayer2D = $ShootPlayer
@onready var hit_player: AudioStreamPlayer2D = $HitPlayer
@onready var revive_player: AudioStreamPlayer2D = $RevivePlayer
@onready var muzzle_flash: MuzzleFlash = $MuzzleFlash
@onready var sprite_2d: Sprite2D = %Sprite2D

var enemy_level := 1
var disable_decay_factor := .9
var can_shoot := true

func _ready() -> void:
	reset()
	
	
func reset() -> void:
	enemy_level = 1
	disable(true)
	_start_shoot_timer()
	
	
func _start_shoot_timer() -> void:
	var cur_delay: float = GameMath.get_scaled_value(base_shoot_delay, enemy_level, -1.1)
	#print(name + " starting shoot timer: " + str(cur_delay))
	var rand_delay: float = cur_delay + randf_range(.2, 1.2)
	shoot_timer.start(rand_delay)


func _enable() -> void:
	#print('enabled')
	visible = true
	can_shoot = true
	collision_shape_2d.set_deferred("disabled", false)
	revive_player.play()
	_start_shoot_timer()
	
	
func disable(is_temporary: bool = true) -> void:
	#print('disabled')
	can_shoot = false
	collision_shape_2d.set_deferred("disabled", true)
	
	if is_temporary:
		visible = false
		var hit_timeout_secs :float = GameMath.get_scaled_value(base_revive_delay + randf_range(0, 5), enemy_level, -1.1)
		revive_timer.start(hit_timeout_secs)
	else:
		shoot_timer.stop()
		revive_timer.stop()
		
	
func _on_revive_timer_timeout() -> void:
	_enable()
	

func _on_area_entered(area: Area2D) -> void:
	#print('hit')
	_handle_hit(area)
	
	
func _handle_hit(area: Area2D) -> void:
	await _hit_flash()
	disable()
	hit_player.play()
	enemy_hit.emit(self)
	var projectile := area as PlayerProjectile
	if projectile:
		projectile.handle_hit()
		
		
func _hit_flash() -> void:
	var tween := create_tween()
	HitFlashHelper.add_hit_flash_to_tween(tween, sprite_2d)
	await tween.finished
	
	
func _fire_projectile() -> void:
	#print("enemy position: ", position)
	var projectile: EnemyProjectile = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile)
	#print(start_position)
	projectile.global_position =  global_position
	#negative transform.y is the direction the sprite is facing
	projectile.setup(-transform.y.round())
	shoot_player.play()
	muzzle_flash.emit_flash()
	#print("enemy fired")

func _on_shoot_timer_timeout() -> void:
	if visible and can_shoot:		
		var cur_chance: float = GameMath.get_scaled_value(base_shoot_chance, enemy_level, 1.25)
		if GameMath.chance_check(cur_chance):
			_fire_projectile() 
			#print(name + " fired")
	_start_shoot_timer()
