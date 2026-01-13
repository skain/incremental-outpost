extends Node2D
class_name Main

@onready var score_value: Label = %ScoreValue

const BASE_SCORE := 10
var current_score := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_ui()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _update_ui() -> void:
	score_value.text = str(current_score)

func _on_enemy_hit(enemy: Enemy) -> void:
	current_score += enemy.enemy_level * BASE_SCORE
	_update_ui()
	enemy.enemy_level += 1
