extends Node2D

var enemies: Array[Enemy] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in get_children():
		if node is Enemy:
			enemies.append(node)

func reset_enemies() -> void:
	for enemy in enemies:
		enemy.reset()
		
func disable_enemies() -> void:
	for enemy in enemies:
		enemy.disable(false)
