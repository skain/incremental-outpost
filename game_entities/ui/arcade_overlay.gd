class_name ArcadeOverlay extends CanvasLayer

@onready var score_value: Label = %ScoreValue
@onready var health_1: TextureRect = %Health1
@onready var health_2: TextureRect = %Health2
@onready var health_3: TextureRect = %Health3
	
func update_ui(score: int, player_health: int) -> void:
	score_value.text = str(score)
	_set_player_health(player_health)	

func _set_player_health(player_health: int) -> void:
	if player_health > 0:
		health_1.visible = true
	else:
		health_1.visible = false
		
	if player_health > 1:
		health_2.visible = true
	else:
		health_2.visible = false
		
	if player_health > 2:
		health_3.visible = true
	else:
		health_3.visible = false
