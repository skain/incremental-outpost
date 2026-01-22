extends Area2D
class_name Enemy

signal enemy_hit(enemy:Enemy)

const PROJECTILE_SCENE = preload("res://scenes/enemy_projectile.tscn")

@export var base_shoot_delay: float = 1

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var revive_timer: Timer = $ReviveTimer
@onready var shoot_timer: Timer = $ShootTimer

var enemy_level := 1
var disable_decay_factor := .9

func _ready() -> void:
	_start_shoot_timer()
	print(name + ": " + str(rotation))
	
func _start_shoot_timer() -> void:
	var cur_delay: float = GameMath.get_scaled_value(base_shoot_delay, enemy_level, 1.5)
	#print(name + " starting shoot timer: " + str(cur_delay))
	shoot_timer.start(cur_delay)

func _enable() -> void:
	#print('enabled')
	visible = true
	collision_shape_2d.set_deferred("disabled", false)
	
func _disable() -> void:
	#print('disabled')
	visible = false
	collision_shape_2d.set_deferred("disabled", true)
	var hit_timeout_secs :float =  5 * (disable_decay_factor ** (enemy_level - 1))
	revive_timer.start(hit_timeout_secs)
	
func _on_revive_timer_timeout() -> void:
	_enable()

func _on_area_entered(area: Area2D) -> void:
	#print('hit')
	_disable()
	enemy_hit.emit(self)
	area.queue_free()
	
func _fire_projectile(direction: Vector2, offset: Vector2) -> void:
	#print("enemy position: ", position)
	var projectile: EnemyProjectile = PROJECTILE_SCENE.instantiate()
	get_parent().add_child(projectile)
	var start_position := global_position + offset
	#print(start_position)
	projectile.global_position =  start_position
	projectile.setup(direction)
	#print("enemy fired")

func _on_shoot_timer_timeout() -> void:
	_fire_projectile(-transform.y.round(), Vector2.ZERO)
	#print(name + " fired")
	_start_shoot_timer()
