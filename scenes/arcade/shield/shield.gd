class_name Shield extends Area2D

signal autoshield_engaged
signal autoshield_disengaged

const HIT_AUDIO : AudioStream = preload("res://assets/sounds/8-bit Sound Library/Hit_00.wav")
const BOUNCE_AUDIO : AudioStream = preload("res://assets/sounds/8-bit Sound Library/Shoot_02.wav")

var _pulse_tween: Tween
var _shield_bounce_enabled := false
var _autoshield_enabled := false
var _reverse_shield_eye_anim := false

# Track overall active status for ShieldsManager queries
var is_active := false
# Track independent activation sources
var _is_manual_active := false
var _is_autoshield_active := false

@export var pulse_speed := 0.2
@export var pulse_max_amount := 1.25
@export var pulse_min_amount := 0.75
@export var bounce_color := Color("c1ff7a")

@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D
@onready var shield_on_player: AudioStreamPlayer2D = %ShieldOnPlayer
@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var autoshield_animation_player: AnimationPlayer = %AutoshieldAnimationPlayer
@onready var autoshield_container: Node2D = %AutoshieldContainer
@onready var autoshield_area_2d: Area2D = %AutoshieldArea2D
@onready var shield_eye: Sprite2D = %ShieldEye


func _ready() -> void:
	shield_off(true)
	shield_off(false)
	_set_shield_upgrades()


## Request turning on the shield from either manual player input or autoshield logic.
func shield_on(is_auto := false) -> void:
	if is_auto:
		_is_autoshield_active = true
	else:
		_is_manual_active = true

	if not is_active:
		is_active = true
		collision_shape_2d.set_deferred("disabled", false)
		_start_pulse_tween()
		sprite_2d.show()
		if not shield_on_player.playing:
			var tween := create_tween()
			shield_on_player.volume_db = -80
			shield_on_player.play()
			tween.tween_property(shield_on_player, "volume_db", -10, 0.1)


## Request turning off the shield from either manual player input or autoshield logic.
func shield_off(is_auto := false) -> void:
	if is_auto:
		_is_autoshield_active = false
	else:
		_is_manual_active = false

	# Only physically disable components if NO system currently requires the shield active
	if not _is_manual_active and not _is_autoshield_active:
		is_active = false
		collision_shape_2d.set_deferred("disabled", true)
		sprite_2d.hide()
		_stop_pulse_tween()
		if shield_on_player.playing:
			var tween := create_tween()
			tween.tween_property(shield_on_player, "volume_db", -80, 0.3)
			tween.tween_callback(shield_on_player.stop)


## Helper for ShieldsManager when clearing player inputs (e.g., energy depleted or keys released).
func clear_manual_activation() -> void:
	shield_off(false)


func _start_pulse_tween() -> void:
	if _pulse_tween and _pulse_tween.is_running():
		_pulse_tween.kill()
	
	_pulse_tween = create_tween().set_loops()
	_pulse_tween.tween_property(sprite_2d, "self_modulate", Color(pulse_max_amount, pulse_max_amount, pulse_max_amount, 1), pulse_speed).from(Color(pulse_min_amount, pulse_min_amount, pulse_min_amount, 1)).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_pulse_tween.tween_property(sprite_2d, "self_modulate", Color(pulse_min_amount, pulse_min_amount, pulse_min_amount, 1), pulse_speed).set_trans(Tween.TRANS_SINE)


func _stop_pulse_tween() -> void:
	if _pulse_tween:
		_pulse_tween.kill()


func _set_shield_upgrades() -> void:
	var angle := roundi(rotation_degrees)
	match angle:
		0:
			_shield_bounce_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.TOP_SHIELD_BOUNCE)
			_autoshield_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.AUTOSHIELD_TOP)
		90:
			_shield_bounce_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.RIGHT_SHIELD_BOUNCE)
			_autoshield_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.AUTOSHIELD_RIGHT)
			_reverse_shield_eye_anim = true
		180:
			_shield_bounce_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.BOTTOM_SHIELD_BOUNCE)
			_autoshield_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.AUTOSHIELD_BOTTOM)
		270:
			_shield_bounce_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.LEFT_SHIELD_BOUNCE)
			_autoshield_enabled = SkillsManager.get_as_bool(SkillTreeNode.AffectedStat.AUTOSHIELD_LEFT)
			_reverse_shield_eye_anim = true
		_:
			print("Error: " + name + " has unrecognized rotation: ", rotation_degrees)
	
	if _shield_bounce_enabled:
		modulate = bounce_color
	
	_disable_autoshield()
	if _autoshield_enabled:
		_enable_autoshield()


func _disable_autoshield() -> void:
	autoshield_container.hide()
	autoshield_area_2d.monitoring = false


func _enable_autoshield() -> void:
	autoshield_area_2d.monitoring = true
	autoshield_container.show()
	autoshield_animation_player.play("scan")
	if _reverse_shield_eye_anim:
		shield_eye.flip_h = true


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


func _on_autoshield_area_2d_area_entered(_area: Area2D) -> void:
	shield_eye.modulate = Color.RED
	shield_on(true)
	autoshield_engaged.emit()


func _on_autoshield_area_2d_area_exited(_area: Area2D) -> void:
	shield_eye.modulate = Color.WHITE
	shield_off(true)
	autoshield_disengaged.emit()
