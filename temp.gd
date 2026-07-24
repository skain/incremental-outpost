extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D

#func _ready() -> void:
	#var rect := get_viewport_rect()
	#print("rect:", rect)

func _process(delta: float) -> void:
	var speed := 3.0
	var move_to := Vector2(get_viewport_rect().size.x, 0)
	var move_dir := (move_to - sprite_2d.global_position) * delta
	print("move_dir:", move_dir)
	sprite_2d.global_position = sprite_2d.global_position + move_dir
	
	
	
