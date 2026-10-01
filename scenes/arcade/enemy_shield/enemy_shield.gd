class_name EnemyShield extends Area2D

func _ready() -> void:
	SignalBus.shield_gen_enemies_count_changed.connect(on_shield_gen_enemies_count_changed)
	monitoring = false
	_set_status_by_active_generators()


func turn_on() -> void:
	monitorable = true
	show()


func turn_off() -> void:
	monitorable = false
	hide()


func on_shield_gen_enemies_count_changed() -> void:
	_set_status_by_active_generators()


func _set_status_by_active_generators() -> void:
	var generators := get_tree().get_nodes_in_group("ShieldGenEnemies")
	if generators.size() > 0:
		turn_on()
	else:
		turn_off()
	
