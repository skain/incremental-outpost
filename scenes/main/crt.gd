class_name CRT extends Node2D

@export var debug: bool = false

@onready var crt_panel: CRTPanel = %CRTPanel

func run_upgrader() -> void:
	crt_panel.set_visibility(true)
	crt_panel.run_endgame_interstitial()
	
func hide_crt() -> void:
	crt_panel.set_visibility(false)
