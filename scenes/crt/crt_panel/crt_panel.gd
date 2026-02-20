class_name CRTPanel extends Node2D

@onready var camera_2d: Camera2D = %Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_camera_current() -> void:
	camera_2d.make_current()
	
