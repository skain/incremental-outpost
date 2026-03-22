class_name ArcadeUI extends CanvasLayer

@onready var score_value: Label = %ScoreValue
@onready var hull_plating_1: TextureRect = %HullPlating1
@onready var hull_plating_2: TextureRect = %HullPlating2
@onready var hull_plating_3: TextureRect = %HullPlating3
	
func update_ui(score: int, player_hull_plating: int) -> void:
	score_value.text = str(score)
	_set_player_hull_plating(player_hull_plating)	


func _set_player_hull_plating(player_hull_plating: int) -> void:
	if player_hull_plating > 0:
		hull_plating_1.visible = true
	else:
		hull_plating_1.visible = false
		
	if player_hull_plating > 1:
		hull_plating_2.visible = true
	else:
		hull_plating_2.visible = false
		
	if player_hull_plating > 2:
		hull_plating_3.visible = true
	else:
		hull_plating_3.visible = false
