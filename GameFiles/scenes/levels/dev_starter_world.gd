extends Node2D

@onready var pause_screen: Control = $UI/PauseScreen
@onready var general_store: Control = $UI/general_store
@onready var time_of_day_ui: Control = $UI/TimeOfDayUI





func _ready() -> void:
	Events.connect("hide_buttons_and_tod", Callable(_hide_ui))
	Events.connect("show_buttons_and_tod", Callable(_show_ui))


### UI
func _hide_ui():
	time_of_day_ui.visible = false
	#btn_sword.visible = false
	#btn_hoe.visible = false
	#btn_seed.visible = false

func _show_ui():
	time_of_day_ui.visible = true
	#btn_sword.visible = true
	#btn_hoe.visible = true
	#btn_seed.visible = true
