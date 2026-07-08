class_name Shield extends Area2D

const HIT_AUDIO : AudioStream = preload("res://assets/sounds/8-bit Sound Library/Hit_00.wav")
const BOUNCE_AUDIO : AudioStream = preload("res://assets/sounds/8-bit Sound Library/Shoot_02.wav")

var _pulse_tween: Tween
var _shield_bounce_enabled := false
var _autoshield_enabled := false

@export var pulse_speed := 0.2
@export var pulse_max_amount := 1.25
@export var pulse_min_amount := 0.75
@export var bounce_color := Color("c1ff7a")

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var shield_on_player: AudioStreamPlayer2D = %ShieldOnPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var autoshield_animation_player: AnimationPlayer = %AutoshieldAnimationPlayer
@onready var autoshield_container: Node2D = %AutoshieldContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shield_off()
	_set_shield_upgrades()

func shield_on() -> void:
	collision_shape_2d.set_deferred("disabled", false)
	_start_pulse_tween()
	sprite_2d.show()
	if not shield_on_player.playing:
		var tween := create_tween()
		shield_on_player.volume_db = -80
		shield_on_player.play()
		tween.tween_property(shield_on_player, "volume_db", -10, 0.1)
	
func shield_off() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	sprite_2d.hide()
	_stop_pulse_tween()
	if shield_on_player.playing:
		var tween := create_tween()
		tween.tween_property(shield_on_player, "volume_db", -80, 0.3)
		tween.tween_callback(shield_on_player.stop)
		
func _start_pulse_tween() -> void:
	# 1. Kill the previous tween if it exists and is active
	if _pulse_tween and _pulse_tween.is_running():
		_pulse_tween.kill()
	
	# 2. Create the new tween
	_pulse_tween = create_tween().set_loops()
	_pulse_tween.tween_property(sprite_2d, "self_modulate", Color(pulse_max_amount, pulse_max_amount, pulse_max_amount, 1), pulse_speed).from(Color(pulse_min_amount, pulse_min_amount, pulse_min_amount, 1)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_pulse_tween.tween_property(sprite_2d, "self_modulate", Color(pulse_min_amount, pulse_min_amount, pulse_min_amount, 1), pulse_speed).set_trans(Tween.TRANS_SINE)
	
func _stop_pulse_tween() -> void:
	if _pulse_tween:
		_pulse_tween.kill()
		
func _set_shield_upgrades() -> void:
	match rotation_degrees:
		0.0:
			_shield_bounce_enabled = GameManager.skills_manager.get_top_shield_bounce_enabled()
			_autoshield_enabled = GameManager.skills_manager.get_top_autoshield_enabled()
		90.0:
			_shield_bounce_enabled = GameManager.skills_manager.get_right_shield_bounce_enabled()
			_autoshield_enabled = GameManager.skills_manager.get_right_autoshield_enabled()
			autoshield_animation_player.speed_scale = -1.0
		180.0:
			_shield_bounce_enabled = GameManager.skills_manager.get_bottom_shield_bounce_enabled()
			_autoshield_enabled = GameManager.skills_manager.get_bottom_cannon_autofire_enabled()
		270.0:
			_shield_bounce_enabled = GameManager.skills_manager.get_left_shield_bounce_enabled()
			_autoshield_enabled = GameManager.skills_manager.get_left_autoshield_enabled()
			autoshield_animation_player.speed_scale = -1.0
		_:
			print("Error: " + name + " has unrecognized rotation: ", rotation_degrees)
	
	if _shield_bounce_enabled:
		modulate = bounce_color
	
	autoshield_container.hide()
	if _autoshield_enabled:
		_enable_autoshield()


func _enable_autoshield() -> void:
	autoshield_container.show()
	autoshield_animation_player.play("scan")



#region event handlers
	
func _handle_hit(enemy_projectile: EnemyProjectile) -> void:
	if enemy_projectile:
		if _shield_bounce_enabled:
			enemy_projectile.handle_bounce()
			SfxManager.play_sfx(BOUNCE_AUDIO, global_position)
		else:
			enemy_projectile.handle_hit()
			SfxManager.play_sfx(HIT_AUDIO, global_position)

func _on_area_entered(area: Area2D) -> void:
	var projectile := area as EnemyProjectile
	_handle_hit(projectile)

#endregion
