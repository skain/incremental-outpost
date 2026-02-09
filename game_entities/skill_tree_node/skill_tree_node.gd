@tool
class_name SkillTreeNode extends Node2D

enum State { UNAVAILABLE, AFFORDABLE, UNAFFORDABLE, PURCHASED }

@export_group("Textures")
@export var icon_texture: Texture2D:
	set(v):
		icon_texture = v
		_update_visuals()

@export_group("Current Status")
@export var current_state: State = State.UNAVAILABLE:
	set(v):
		current_state = v
		_update_visuals()

# Use standard variables and manual assignment to avoid @onready tool-lag
var frame: Sprite2D
var glass: Sprite2D
var icon: Sprite2D

func _ready() -> void:
	_update_visuals()

# Helper to find nodes safely in tool mode
func _ensure_nodes() -> bool:
	if not frame: frame = get_node_or_null("%Frame")
	if not glass: glass = get_node_or_null("%Glass")
	if not icon: icon = get_node_or_null("%Icon")
	return frame != null and glass != null and icon != null

func _update_visuals() -> void:
	# If nodes aren't found yet, try to find them
	if not _ensure_nodes():
		return
	
	# Now that we know nodes exist, we can proceed
	icon.texture = icon_texture
	
	match current_state:
		State.UNAVAILABLE:
			self.modulate = Color(0.2, 0.2, 0.2, 0.4)
			icon.visible = false
	
		State.UNAFFORDABLE:
			self.modulate = Color(0.5, 0.5, 0.5, 1.0)
			icon.visible = true
			icon.modulate = Color.WHITE
			glass.self_modulate = Color.WHITE
	
		State.AFFORDABLE:
			self.modulate = Color(1.0, 1.0, 1.0, 1.0)
			icon.visible = true
			icon.modulate = Color.WHITE
			glass.self_modulate = Color.WHITE

		State.PURCHASED:
			self.modulate = Color(1.5, 1.5, 1.5, 1.0)
			icon.visible = true
			icon.modulate = Color.BLACK
			glass.self_modulate = Color(1, 0.7, 0, 1)

# This function detects clicks on the node
func _input(event: InputEvent) -> void:
	# Only run the click logic when the game is actually playing
	if Engine.is_editor_hint():
		return
		
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Check if the click was inside our node's area
		# We use the Frame's texture size to determine the clickable area
		if frame and frame.get_rect().has_point(to_local(event.position)):
			_cycle_state()

func _cycle_state() -> void:
	# Get the total number of states in our enum
	var num_states := State.size()
	# Increment the state and wrap around using the modulo operator
	current_state = ((current_state + 1) % num_states) as State
	print("State changed to: ", State.keys()[current_state])
