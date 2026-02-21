extends Area2D
class_name Player

signal player_hit
signal start_game_pressed

@onready var hit_player: AudioStreamPlayer2D = $HitPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var cannons: Node2D = $Cannons

var max_health := 3
var health := 3

func _ready() -> void:
	reset()
	
func _process(_delta: float) -> void:
	if health > 0:
		cannons.handle_firing()
	elif Input.is_action_pressed("start_game"):
		start_game_pressed.emit()
		
func die() -> void:
	cannons.disable_cannons()	
	
func reset() -> void:
	health = max_health
	cannons.reset_cannons()	
	
func make_camera_current() -> void:
	camera_2d.make_current()

func _handle_hit(projectile: EnemyProjectile) -> void:
	if not health > 0:
		return
	player_hit.emit()
	projectile.handle_hit()
	hit_player.play()
	_shake_camera(15.0, 0.25)
	
func _shake_camera(intensity: float, duration: float) -> void:
	var shake_tween := create_tween()

	# We use TRANS_SINE or TRANS_QUAD for a "snappy" feel
	for i in range(5):
		var offset := Vector2(randf_range(-1, 1), randf_range(-1, 1)) * intensity
		shake_tween.tween_property(camera_2d, "offset", offset, duration / 10.0).set_trans(Tween.TRANS_SINE)
		shake_tween.tween_property(camera_2d, "offset", Vector2.ZERO, duration / 10.0).set_trans(Tween.TRANS_SINE)

func _on_cannon_hit(_cannon_direction: Vector2) -> void:
	_shake_camera(5.0, 0.125)
	
func _on_area_entered(area: Area2D) -> void:
	_handle_hit(area)
