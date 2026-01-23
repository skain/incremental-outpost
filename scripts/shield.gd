extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shield_off()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shield_on() -> void:
	collision_shape_2d.set_deferred("disabled", false)
	visible = true
	
func shield_off() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	visible = false

func _on_area_entered(area: Area2D) -> void:
	area.queue_free()
