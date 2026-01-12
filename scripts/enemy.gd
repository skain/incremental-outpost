extends Node2D
class_name Enemy

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _enable() -> void:
	print('enabled')
	visible = true
	collision_shape_2d.set_deferred("disabled", false)
	
func _disable() -> void:
	print('disabled')
	visible = false
	collision_shape_2d.set_deferred("disabled", true)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "PlayerProjectile":
		print('hit')
		_disable()
		area.queue_free()
