class_name Cannons extends Node2D

@onready var top_cannon: Cannon = $TopCannon
@onready var right_cannon: Cannon = $RightCannon
@onready var bottom_cannon: Cannon = $BottomCannon
@onready var left_cannon: Cannon = $LeftCannon
@onready var cannons_node: Cannons = %Cannons

@export var player: Player

var can_fire := true
var cannons: Array[Cannon] = []


func _ready() -> void:
	for node in cannons_node.find_children("*", "Cannon", false, true):
		cannons.append(node)


func _process(_delta: float) -> void:
	if can_fire:
		_handle_firing()
	
	_handle_drone_deploy()


func _handle_drone_deploy() -> void:
	if Input.is_action_just_pressed("deploy_drone"):
		_try_deploy_drone()


func _try_deploy_drone() -> void:
	var to_repair : Cannon = null
	for cannon in cannons:
		if cannon.cur_state == Cannon.CannonStates.DESTROYED:
			to_repair = cannon
			break
	
	if to_repair:
		if to_repair.try_begin_drone_repair():
			player.decrement_repair_drones()
		else:
			# play fail to repair sound?
			pass
	else:
		#play fail to repair sound?
		print("no cannons found to repair")


func _handle_firing() -> void:
		if Input.is_action_just_pressed("fire_up"):
			top_cannon.fire_projectile(player)
		elif Input.is_action_just_pressed("fire_down"):
			bottom_cannon.fire_projectile(player)
		elif Input.is_action_just_pressed("fire_left"):
			left_cannon.fire_projectile(player)
		elif Input.is_action_just_pressed("fire_right"):
			right_cannon.fire_projectile(player)


func reset_cannons() -> void:
	for cannon in cannons:
		cannon.reset()


func disable_cannons() -> void:
	for cannon in cannons:
		cannon.disable()
