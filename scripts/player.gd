extends Area2D
class_name Player

signal player_hit
signal start_game_pressed

@onready var top_shield: Area2D = $Shields/TopShield
@onready var right_shield: Area2D = $Shields/RightShield
@onready var bottom_shield: Area2D = $Shields/BottomShield
@onready var left_shield: Area2D = $Shields/LeftShield
@onready var top_cannon: Cannon = $Canons/TopCannon
@onready var right_cannon: Cannon = $Canons/RightCannon
@onready var bottom_cannon: Cannon = $Canons/BottomCannon
@onready var left_cannon: Cannon = $Canons/LeftCannon
@onready var hit_player: AudioStreamPlayer2D = $HitPlayer
@onready var camera_2d: Camera2D = $Camera2D

var max_health := 3
var health := 3
var shield_determiner := ShieldDeterminer.new()

func _ready() -> void:
	shield_determiner.shield_changed.connect(_update_shields)
	reset()
	
func _process(_delta: float) -> void:
	if health > 0:
		_handle_firing()
	elif Input.is_action_pressed("start_game"):
		start_game_pressed.emit()
	
func _input(event: InputEvent) -> void:
	shield_determiner.set_input(event)
	
func _update_shields(dir: String) -> void:
	top_shield.shield_off()
	right_shield.shield_off()
	bottom_shield.shield_off()
	left_shield.shield_off()
	
	match dir:
		"up":
			top_shield.shield_on()
		"right":
			right_shield.shield_on()
		"down":
			bottom_shield.shield_on()
		"left":
			left_shield.shield_on()
	
func _handle_firing() -> void:
	var parent := get_parent()
	if Input.is_action_just_pressed("fire_up"):
		top_cannon.fire_projectile(parent)
	elif Input.is_action_just_pressed("fire_down"):
		bottom_cannon.fire_projectile(parent)
	elif Input.is_action_just_pressed("fire_left"):
		left_cannon.fire_projectile(parent)
	elif Input.is_action_just_pressed("fire_right"):
		right_cannon.fire_projectile(parent)
	
func die() -> void:
	_reset_cannons()	
	
func reset() -> void:
	health = max_health
	_reset_cannons()	

func _reset_cannons() -> void:
	top_cannon.reset()
	bottom_cannon.reset()
	left_cannon.reset()
	right_cannon.reset()

func _handle_hit(projectile: EnemyProjectile) -> void:
	if not health > 0:
		return
	player_hit.emit()
	projectile.handle_hit()
	hit_player.play()
	_shake_camera(15.0, 0.25)
	
func _shake_camera(intensity: float, duration: float) -> void:
	# 2. SETUP: Create a new tween
	var shake_tween := create_tween()

	# 3. ANIMATE: Rapidly move back and forth
	# We use TRANS_SINE or TRANS_QUAD for a "snappy" feel
	for i in range(5):
		var offset := Vector2(randf_range(-1, 1), randf_range(-1, 1)) * intensity
		shake_tween.tween_property(camera_2d, "offset", offset, duration / 10.0).set_trans(Tween.TRANS_SINE)
		shake_tween.tween_property(camera_2d, "offset", Vector2.ZERO, duration / 10.0).set_trans(Tween.TRANS_SINE)

func _on_cannon_hit(cannon_direction: Vector2) -> void:
	_shake_camera(5.0, 0.125)
	
func _on_area_entered(area: Area2D) -> void:
	_handle_hit(area)
