class_name EnemiesContainer extends Node2D

var enemies: Array[Enemy] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for node in find_children("*", "Enemy", false, true):
		enemies.append(node)


func reset_enemies() -> void:
	for enemy in enemies:
		enemy.reset()


func disable_enemies() -> void:
	for enemy in enemies:
		enemy.disable(false)


func connect_hit_handler(handler: Callable) -> void:
	for enemy in enemies:
		enemy.enemy_hit.connect(handler)
