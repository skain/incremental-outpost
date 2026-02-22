class_name Shield extends Area2D

var pulse_tween: Tween

@export var pulse_speed := 0.2
@export var pulse_max_amount := 1.5
@export var pulse_min_amount := 0.75

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var hit_player: AudioStreamPlayer2D = %HitPlayer
@onready var shield_on_player: AudioStreamPlayer2D = %ShieldOnPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shield_off()

func shield_on() -> void:
	collision_shape_2d.set_deferred("disabled", false)
	_start_pulse_tween()
	visible = true
	if not shield_on_player.playing:
		var tween := create_tween()
		shield_on_player.volume_db = -80
		shield_on_player.play()
		tween.tween_property(shield_on_player, "volume_db", -10, 0.1)
	
func shield_off() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	visible = false
	_stop_pulse_tween()
	if shield_on_player.playing:
		var tween := create_tween()
		tween.tween_property(shield_on_player, "volume_db", -80, 0.3)
		tween.tween_callback(shield_on_player.stop)
		
func _start_pulse_tween() -> void:
	# 1. Kill the previous tween if it exists and is active
	if pulse_tween and pulse_tween.is_running():
		pulse_tween.kill()
	
	# 2. Create the new tween
	pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property(sprite_2d, "self_modulate", Color(pulse_max_amount, pulse_max_amount, pulse_max_amount, 1), pulse_speed).from(Color(pulse_min_amount, pulse_min_amount, pulse_min_amount, 1)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	pulse_tween.tween_property(sprite_2d, "self_modulate", Color(pulse_min_amount, pulse_min_amount, pulse_min_amount, 1), pulse_speed).set_trans(Tween.TRANS_SINE)
	
func _stop_pulse_tween() -> void:
	if pulse_tween:
		pulse_tween.kill()
	
func _handle_hit(enemy_projectile: EnemyProjectile) -> void:
	if enemy_projectile:
		enemy_projectile.handle_hit()
		hit_player.play()

func _on_area_entered(area: Area2D) -> void:
	var projectile := area as EnemyProjectile
	_handle_hit(projectile)
