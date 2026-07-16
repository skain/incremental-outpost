class_name QuantumTeslaCannon extends Sprite2D

@export var player: Player
@export var radius: float = 200.0
@export var speed: float = 2.0

@onready var cpu_particles_2d: CPUParticles2D = %CPUParticles2D
@onready var radial_cooldown: RadialCooldown = %RadialCooldown
@onready var scan_timer: Timer = %ScanTimer

var angle := 0.0
var cooldown := 10.0
var enemies_in_sight: Array[Enemy] = []
var speed_modifier := 0.1


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	if not visible:
		return
		
	_do_orbit(delta)
	_scan_for_enemies()


func reset() -> void:
	radial_cooldown.set_one_shot(true)
	cooldown = GameManager.skills_manager.get_qtc_cooldown()
	if cooldown == 0.0:
		disable()
		return
	
	enable()


func disable() -> void:
		hide()
		set_process(false)
		scan_timer.stop()
		cpu_particles_2d.emitting = false


func enable() -> void:
	set_process(true)
	
	radial_cooldown.cooldown_duration = cooldown
	radial_cooldown.start_cooldown()
	
	scan_timer.start()
	
	cpu_particles_2d.emitting = true


func _do_orbit(delta: float) -> void:
	angle += speed * speed_modifier * delta
	angle = wrapf(angle, 0.0, TAU)
	
	var offset: Vector2 = Vector2(cos(angle), sin(angle)) * radius
	global_position = player.global_position + offset


func _scan_for_enemies() -> void:
	# Don't shoot if the cannon is currently cooling down
	if radial_cooldown.is_on_cooldown():
		return
		
	if enemies_in_sight.is_empty():
		return
		
	var closest_enemy: Enemy = null
	var min_distance: float = INF
	
	# Linear search for the closest validated target in line of sight
	for enemy in enemies_in_sight:
		if is_instance_valid(enemy):
			var dist := global_position.distance_to(enemy.global_position)
			if dist < min_distance:
				min_distance = dist
				closest_enemy = enemy
				
	if closest_enemy:
		_shoot_enemy(closest_enemy)


func _shoot_enemy(enemy: Enemy) -> void:
	# Trigger the cooldown phase immediately upon firing
	radial_cooldown.start_cooldown()
	
	_draw_laser_beam(enemy.global_position)
	print("shooting")
	#destroy enemy


## Returns an array of enemy nodes that have a clear line of sight
func _get_visible_enemies() -> Array[Enemy]:
	var visible_list: Array[Enemy] = []
	
	# Fetch the 2D direct space state for physics queries
	var space_state := get_world_2d().direct_space_state
	if not space_state:
		return visible_list
		
	var enemies := get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemies:
		if not is_instance_valid(enemy) or not enemy is Node2D:
			continue
			
		# Configure the raycast query
		var query := PhysicsRayQueryParameters2D.create(global_position, enemy.global_position)
		
		# Layer 3 is ON, Layer 2 is OFF, Layer 1 is ON (read right to left)
		query.collision_mask = 0b0101
		
		query.collide_with_areas = true
		
		# Cast the ray
		var result := space_state.intersect_ray(query)
		
		# Check the result
		if result:
			# If the collider we hit is the enemy, the line of sight is clear!
			if result.collider == enemy:
				visible_list.append(enemy as Enemy)
			# If result.collider == player, it hit the player first and gets ignored
			
	return visible_list


func _draw_laser_beam(target_position: Vector2) -> void:
	# 1. Create a new instance of Line2D
	var laser := Line2D.new()
	
	# 2. Configure its visual properties
	laser.default_color = Color.RED
	laser.width = 3.0
	
	# Anti-aliasing makes the line look much smoother, highly recommended for lasers
	laser.antialiased = true 
	
	# 3. Add the line as a child of the orbiter
	add_child(laser)
	
	# 4. Define the local points (starting at center, ending at target)
	laser.add_point(Vector2.ZERO)
	
	# Convert the enemy's global position to the local space of this newly added line
	var local_target_pos := laser.to_local(target_position)
	laser.add_point(local_target_pos)
	
	# 5. Create a dynamic fade-and-destroy sequence using a Tween
	var tween := create_tween()
	
	# Fades the alpha value to 0 over 0.15 seconds
	tween.tween_property(laser, "modulate:a", 0.0, 0.15)
	
	# CRITICAL: Automatically free the node from memory once the fade finishes
	tween.tween_callback(laser.queue_free)

#region event handlers
func _on_radial_cooldown_cooldown_complete() -> void:
	# Left blank intentionally. Cooldown loops are handled explicitly via _shoot_enemy()
	pass


func _on_scan_timer_timeout() -> void:
	enemies_in_sight = _get_visible_enemies()
	scan_timer.start()

#endregion
