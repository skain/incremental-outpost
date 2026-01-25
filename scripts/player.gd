extends Area2D
class_name Player

signal player_hit

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

var health: int = 3
var shield_determiner := ShieldDeterminer.new()

func _ready() -> void:
	shield_determiner.shield_changed.connect(_update_shields)
	
func _process(delta: float) -> void:
	_handle_firing()
	
func _input(event: InputEvent) -> void:
	shield_determiner.set_input(event)
	
func _update_shields(dir: String) -> void:
	print(dir)
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

#func _fire_projectile(direction: Vector2, offset: Vector2) -> void:
	##print("player position: ", position)
	#var projectile: PlayerProjectile = PROJECTILE_SCENE.instantiate()
	#get_parent().add_child(projectile)
	#var start_position := global_position + offset
	##print(start_position)
	#projectile.global_position =  start_position
	#projectile.setup(direction)
	##print("fired")
#
	#can_fire = false  # Prevent further firing
	#await get_tree().create_timer(fire_rate).timeout  # Wait for fire_rate seconds
	#can_fire = true  # Allow firing again after the delay
	
func die() -> void:
	top_cannon.can_fire = false
	bottom_cannon.can_fire = false
	left_cannon.can_fire = false
	right_cannon.can_fire = false


func _on_area_entered(area: Area2D) -> void:
	player_hit.emit()
	area.queue_free()
