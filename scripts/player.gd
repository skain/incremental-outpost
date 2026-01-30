extends Area2D
class_name Player

signal player_hit
signal start_game_pressed

#const PROJECTILE_SCENE = preload("res://scenes/player_projectile.tscn")
#
#@export var fire_rate: float = 0.2

@onready var top_shield: Area2D = $Shields/TopShield
@onready var right_shield: Area2D = $Shields/RightShield
@onready var bottom_shield: Area2D = $Shields/BottomShield
@onready var left_shield: Area2D = $Shields/LeftShield
@onready var top_cannon: Cannon = $Node2D/TopCannon
@onready var right_cannon: Cannon = $Node2D/RightCannon
@onready var bottom_cannon: Cannon = $Node2D/BottomCannon
@onready var left_cannon: Cannon = $Node2D/LeftCannon

var max_health := 3
var health := 3
var shield_determiner := ShieldDeterminer.new()

func _ready() -> void:
	shield_determiner.shield_changed.connect(_update_shields)
	reset()
	
func _process(delta: float) -> void:
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
	_set_can_fire(false)	
	
func reset() -> void:
	health = max_health
	_set_can_fire(true)	

func _set_can_fire(can_fire: bool) -> void:
	top_cannon.reset()
	bottom_cannon.reset()
	left_cannon.reset()
	right_cannon.reset()

func _on_area_entered(area: Area2D) -> void:
	player_hit.emit()
	var projectile := area as EnemyProjectile
	projectile.handle_hit()
