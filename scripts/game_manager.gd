class_name GameManagerAutoload extends Node

@onready var game_data:GameData = load("user://game_data.tres")

var _base_points_to_bucks_rate: float = 0.1

func _ready() -> void:
	if not game_data:
		game_data = GameData.new()

func set_points(new_points: int) -> void:
	game_data.current_points = new_points
	
func get_points_to_bucks_rate() -> float:
	#logic to handle upgrades to conversion rate will go here
	return _base_points_to_bucks_rate
	
func convert_points_to_bucks() -> int:
	var new_bucks:int = floor(game_data.current_points * get_points_to_bucks_rate())
	set_points(0)
	return new_bucks
