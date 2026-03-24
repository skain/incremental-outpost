class_name NewGameInterstitial extends MarginContainer

signal new_game_screen_complete

enum STATES {PAGE1, PAGE2}

var _current_state := STATES.PAGE1

@onready var page_1: TypingLabel = %Page1
@onready var page_2: TypingLabel = %Page2
@onready var ok_button: Button = %OkButton

func _ready() -> void:
	ok_button.hide()
	page_2.hide()
	_show_page_1()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match _current_state:
			STATES.PAGE1:
				page_1.finish_typing()
			STATES.PAGE2:
				page_2.finish_typing()

func _show_page_1() -> void:
	page_1.show()
	page_1.start_typing()
	
func _show_page_2() -> void:
	_current_state = STATES.PAGE2
	page_1.hide()
	page_2.show()
	page_2.start_typing()


func _on_crt_button_pressed() -> void:
	match _current_state:
		STATES.PAGE1:
			ok_button.hide()
			_show_page_2()
		STATES.PAGE2:
			new_game_screen_complete.emit()


func _on_typing_complete() -> void:
	ok_button.show()
