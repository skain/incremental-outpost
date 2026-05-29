class_name SmartBombScreenEffect extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var mat := color_rect.material as ShaderMaterial

func _ready() -> void:
	hide()

func trigger() -> void:
	show()
	var tween := create_tween()
	
	for i in range(0,2):
		_add_negative(tween, 0.32)
		_add_bw(tween, 0.20)
		_add_normal(tween, 0.16)
		_add_negative_bw(tween, 0.48)
	
	await tween.finished
	hide()

func _add_negative(tween: Tween, length: float) -> void:
	_add_set_mode(tween, true, false) 
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


func _add_set_mode(tween: Tween, neg: bool, bw: bool) -> void:
	tween.tween_callback(func() -> void: _set_mode(neg, bw))


func _set_mode(neg: bool, bw: bool) -> void:
	mat.set_shader_parameter("use_negative", neg)
	mat.set_shader_parameter("use_black_and_white", bw)
