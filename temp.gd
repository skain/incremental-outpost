extends Node2D

@onready var smart_bomb_screen_effect: SmartBombScreenEffect = $SmartBombScreenEffect

func _ready() -> void:
	await smart_bomb_screen_effect.trigger()
	print("done")
