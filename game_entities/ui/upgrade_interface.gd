class_name UpgradeInterface extends Node2D

@onready var upgrade_camera_2d: Camera2D = $UpgradeCamera2D
@onready var upgrade_canvas_layer: CanvasLayer = $UpgradeCanvasLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	#upgrade_camera_2d.zoom = Vector2(sin(0.1 * delta), sin(0.1 * delta))
	
func make_camera_current() -> void:
	upgrade_camera_2d.make_current()
	
func show_upgrade_interface() -> void:
	upgrade_canvas_layer.visible = true
	
func hide_upgrade_interface() -> void:
	upgrade_canvas_layer.visible = false
