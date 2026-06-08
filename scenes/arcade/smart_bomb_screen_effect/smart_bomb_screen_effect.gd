@tool
class_name SmartBombScreenEffect extends CanvasLayer

@onready var whoosh_player: AudioStreamPlayer = %WhooshPlayer
@onready var explosion_player: AudioStreamPlayer = %ExplosionPlayer

@onready var color_rect: ColorRect = $ColorRect
@onready var mat := color_rect.material as ShaderMaterial

@export var use_negative: bool = false:
	set(value):
		use_negative = value
		if Engine.is_editor_hint():
			mat.set_shader_parameter("use_negative", value)

@export var use_bw: bool = false:
	set(value):
		use_bw = value
		if Engine.is_editor_hint():
			mat.set_shader_parameter("use_black_and_white", value)

@export var preserve_blacks: bool = false:
	set(value):
		preserve_blacks = value
		if Engine.is_editor_hint():
			mat.set_shader_parameter("preserve_blacks", value)

func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	else:
		hide()

func trigger() -> void:
	whoosh_player.play()
	show()
	var tween := create_tween()
	
	for i in range(0,1):
		_add_explosion_sound(tween)
		_add_negative_preserve_blacks(tween, 0.15)
		_add_explosion_sound(tween)
		_add_negative(tween, 0.01)
		_add_explosion_sound(tween)
		_add_negative_bw_preserve_blacks(tween, 0.15)
		_add_explosion_sound(tween)
		_add_bw(tween, 0.15)
		_add_explosion_sound(tween)
		_add_normal(tween, 0.10)
		_add_explosion_sound(tween)
		_add_negative_bw_preserve_blacks(tween, 0.25)
	
	await tween.finished
	hide()


func _add_explosion_sound(tween: Tween) -> void:
	if not Engine.is_editor_hint():
		tween.parallel().tween_callback(explosion_player.play)


func _add_negative(tween: Tween, length: float) -> void:
	_add_set_mode(tween, true, false) 
	tween.tween_interval(length)


func _add_negative_preserve_blacks(tween: Tween, length: float) -> void:
	_add_set_mode(tween, true, false, true) 
	tween.tween_interval(length)


func _add_bw(tween: Tween, length: float) -> void:
	_add_set_mode(tween, false, true) 
	tween.tween_interval(length)


func _add_normal(tween: Tween, length: float) -> void:
	_add_set_mode(tween, false, false) 
	tween.tween_interval(length)


func _add_negative_bw(tween: Tween, length: float) -> void:
	_add_set_mode(tween, true, true) 
	tween.tween_interval(length)


func _add_negative_bw_preserve_blacks(tween: Tween, length: float) -> void:
	_add_set_mode(tween, true, true, true) 
	tween.tween_interval(length)


func _add_set_mode(tween: Tween, neg: bool, bw: bool, blacks: bool = false) -> void:
	tween.tween_callback(func() -> void: _set_mode(neg, bw, blacks))


func _set_mode(neg: bool, bw: bool, blacks: bool) -> void:
	mat.set_shader_parameter("use_negative", neg)
	mat.set_shader_parameter("use_black_and_white", bw)
	mat.set_shader_parameter("preserve_blacks", blacks)
