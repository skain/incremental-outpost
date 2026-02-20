class_name SkillTree extends Node2D

@onready var nodes: Node2D = %Nodes
@onready var lines: Node2D = %Lines
@onready var camera_2d: Camera2D = %Camera2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#if not Engine.is_editor_hint():
		#if dev_world_environment:
			#dev_world_environment.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_camera_current() -> void:
	camera_2d.make_current()
	
