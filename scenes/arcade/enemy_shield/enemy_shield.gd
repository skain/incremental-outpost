class_name EnemyShield extends Area2D

func _ready() -> void:
	monitoring = false
	#turn_off()


func _process(_delta: float) -> void:
	pass


func turn_on() -> void:
	monitorable = true
	show()


func turn_off() -> void:
	monitorable = false
	hide()
	
