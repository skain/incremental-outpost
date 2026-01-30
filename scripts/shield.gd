extends Area2D

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var hit_player: AudioStreamPlayer2D = $HitPlayer
@onready var shield_on_player: AudioStreamPlayer2D = $ShieldOnPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shield_off()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shield_on() -> void:
	collision_shape_2d.set_deferred("disabled", false)
	visible = true
	if not shield_on_player.playing:
		var tween := create_tween()
		shield_on_player.volume_db = -80
		shield_on_player.play()
		tween.tween_property(shield_on_player, "volume_db", -10, 0.1)
	
func shield_off() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	visible = false
	if shield_on_player.playing:
		var tween := create_tween()
		tween.tween_property(shield_on_player, "volume_db", -80, 0.3)
		tween.tween_callback(shield_on_player.stop)
	
func _handle_hit(enemy_projectile: EnemyProjectile) -> void:
	if enemy_projectile:
		enemy_projectile.handle_hit()
		hit_player.play()

func _on_area_entered(area: Area2D) -> void:
	var projectile := area as EnemyProjectile
	_handle_hit(projectile)
