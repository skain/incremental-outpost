extends Camera2D

var is_dragging: bool = false
var zoom_step: Vector2 = Vector2(0.1, 0.1)
var min_zoom: Vector2 = Vector2(0.5, 0.5)
var max_zoom: Vector2 = Vector2(2.0, 2.0)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		# Handle Zoom (Scroll Wheel)
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom += zoom_step
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom -= zoom_step
			
			# Clamp the zoom so the player can't zoom into infinity
			zoom = zoom.clamp(min_zoom, max_zoom)

		# Handle Drag State (Left Click or Middle Click)
		if event.button_index == MOUSE_BUTTON_LEFT:
			is_dragging = event.is_pressed()

	# Handle Panning (Mouse Movement)
	elif event is InputEventMouseMotion and is_dragging:
		# Divide by zoom so panning speed matches the current zoom level
		position -= event.relative / zoom
