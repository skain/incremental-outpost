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
var chain_count := 0


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if not is_instance_valid(player):
		return
	
	if not visible:
		return
		
	_do_orbit(delta)
	_try_shoot()


func reset() -> void:
	radial_cooldown.set_one_shot(true)
	chain_count = SkillsManager.get_qtc_chain_count()	
	cooldown = SkillsManager.get_qtc_cooldown()
	
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


func _try_shoot() -> void:
	# Only attempt a shot cycle if off cooldown
	if not radial_cooldown.is_on_cooldown() and not enemies_in_sight.is_empty():
		var first_target := _find_closest_enemy(global_position, enemies_in_sight)
		if first_target:
			# Fire initial shot & start cooldown ONCE here
			radial_cooldown.start_cooldown()
			_shoot_enemy(global_position, first_target)
			_process_chain(first_target)


func _find_closest_enemy(origin_pos: Vector2, candidate_enemies: Array[Enemy]) -> Enemy:
	var closest_enemy: Enemy = null
	var min_distance: float = INF
	
	for enemy in candidate_enemies:
		if is_instance_valid(enemy):
			var dist := origin_pos.distance_to(enemy.global_position)
			if dist < min_distance:
				min_distance = dist
				closest_enemy = enemy
				
	return closest_enemy


func _process_chain(initial_enemy: Enemy) -> void:
	var cur_enemy := initial_enemy
	var hit_enemies: Array[Enemy] = [initial_enemy]
	
	for i in chain_count:
		# Exclude already hit enemies from line-of-sight checks
		var visible := _get_visible_enemies(cur_enemy.global_position, hit_enemies)
		if visible.is_empty():
			break
			
		var next_enemy := _find_closest_enemy(cur_enemy.global_position, visible)
		if not is_instance_valid(next_enemy):
			break
			
		_shoot_enemy(cur_enemy.global_position, next_enemy)
		hit_enemies.append(next_enemy)
		cur_enemy = next_enemy


func _shoot_enemy(from_pos: Vector2, enemy: Enemy) -> void:
	LightningFX.spawn_lightning(get_tree(), from_pos, enemy.global_position, 0.5)
	enemy.take_damage()


## Returns an array of enemy nodes that have a clear line of sight
func _get_visible_enemies(source_pos: Vector2, exclude_list: Array[Enemy] = []) -> Array[Enemy]:
	var visible_list: Array[Enemy] = []
	var space_state := get_world_2d().direct_space_state
	if not space_state:
		return visible_list
		
	var enemies := get_tree().get_nodes_in_group("Enemy")
	
	for enemy in enemies:
		if not is_instance_valid(enemy) or not enemy is Node2D or enemy in exclude_list:
			continue
			
		var query := PhysicsRayQueryParameters2D.create(source_pos, enemy.global_position)
		query.collision_mask = 0b0101
		query.collide_with_areas = true
		
		# Pass already hit enemies + self as raycast exceptions so the ray isn't blocked by them
		var RID_exceptions: Array[RID] = []
		for hit in exclude_list:
			if is_instance_valid(hit):
				RID_exceptions.append(hit.get_rid())
		query.exclude = RID_exceptions
		
		var result := space_state.intersect_ray(query)
		
		if result and result.collider == enemy:
			visible_list.append(enemy as Enemy)
			
	return visible_list


#region event handlers
func _on_scan_timer_timeout() -> void:
	enemies_in_sight = _get_visible_enemies(global_position)
	scan_timer.start()

#endregion
