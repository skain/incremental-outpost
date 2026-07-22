class_name Player extends Area2D

signal player_hit
signal smart_bomb_triggered

@onready var hit_player: AudioStreamPlayer2D = $HitPlayer
@onready var camera_2d: Camera2D = $Camera2D
@onready var cannons: Node2D = $Cannons
@onready var player_sprite: Sprite2D = %Player
@onready var shields: ShieldsManager = %Shields
@onready var qtc: QuantumTeslaCannon = %QuantumTeslaCannon

var hull_plating := 0
var smart_bombs_max := 0
var smart_bombs_left := 0
var is_dead := false


func _process(_delta: float) -> void:
	if hull_plating > -1:
		if not _handle_smart_bomb():
			cannons.handle_firing()


func die() -> void:
	is_dead = true
	cannons.disable_cannons()


func _handle_smart_bomb() -> bool:
	if Input.is_action_just_pressed("smart_bomb") and not is_dead and smart_bombs_left > 0:
		smart_bombs_left -= 1
		_update_smart_bombs_ui()
		smart_bomb_triggered.emit()
		_shake_camera(15.0, 0.25)
		return true
	else:
		return false


func reset() -> void:
	is_dead = false
	hull_plating = SkillsManager.get_hull_plating()
	smart_bombs_max = SkillsManager.get_num_smart_bombs()
	smart_bombs_left = smart_bombs_max
	_update_smart_bombs_ui()
	cannons.reset_cannons()	
	shields.reset()
	qtc.reset()


func make_camera_current() -> void:
	camera_2d.make_current()


func _handle_hit(projectile: EnemyProjectile) -> void:
	if not hull_plating > -1:
		return
	player_hit.emit()
	projectile.handle_hit()
	hit_player.play()
	_hit_flash()
	_shake_camera(15.0, 0.25)


func _hit_flash() -> void:
	var tween := create_tween()

	tween.set_parallel(true)	
	
	HitFlashHelper.add_hit_flash_to_tween(tween, player_sprite)
	
	for node in cannons.find_children("*", "Cannon", false, false):
		var cannon := node as Cannon
		cannon.add_flash_to_tween(tween)


func _shake_camera(intensity: float, duration: float) -> void:
	var shake_tween := create_tween()

	for i in range(5):
		var offset := Vector2(randf_range(-1, 1), randf_range(-1, 1)) * intensity
		shake_tween.tween_property(camera_2d, "offset", offset, duration / 10.0).set_trans(Tween.TRANS_SINE)
		shake_tween.tween_property(camera_2d, "offset", Vector2.ZERO, duration / 10.0).set_trans(Tween.TRANS_SINE)


func _update_smart_bombs_ui() -> void:
	SignalBus.smart_bombs_updated.emit(smart_bombs_max, smart_bombs_left)


func _on_cannon_hit(_cannon_direction: Vector2) -> void:
	_shake_camera(5.0, 0.125)


func _on_area_entered(area: Area2D) -> void:
	_handle_hit(area)
