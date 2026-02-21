class_name Cannons extends Node2D

@onready var top_cannon: Cannon = $TopCannon
@onready var right_cannon: Cannon = $RightCannon
@onready var bottom_cannon: Cannon = $BottomCannon
@onready var left_cannon: Cannon = $LeftCannon
@onready var cannons: Cannons = %Cannons

func handle_firing() -> void:
	var parent := get_parent()
	if Input.is_action_just_pressed("fire_up"):
		top_cannon.fire_projectile(parent)
	elif Input.is_action_just_pressed("fire_down"):
		bottom_cannon.fire_projectile(parent)
	elif Input.is_action_just_pressed("fire_left"):
		left_cannon.fire_projectile(parent)
	elif Input.is_action_just_pressed("fire_right"):
		right_cannon.fire_projectile(parent)
		
func reset_cannons() -> void:
	for cannon: Cannon in cannons.get_children():
		cannon.reset()

func disable_cannons() -> void:
	for cannon: Cannon in cannons.get_children():
		cannon.disable()
