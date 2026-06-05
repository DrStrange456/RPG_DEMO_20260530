extends Node2D

signal activate_clicked

var player_within_range: bool = false
var plyr



func _ready() -> void:
	Events.connect("show_shop_icon", Callable(_set_market_open))
	Events.connect("hide_shop_icon", Callable(_set_market_closed))


func _input(_event: InputEvent) -> void:
	
	# FIXME: This should be handled in the UI_Manager autoload
	
	if plyr and player_within_range:
		if Input.is_action_just_pressed("ui_cancel"):
			# ignore if market sell ui
			if UiManager.active_sell_ui: 
				return
			# 
			var tod = find_anywhere("TimeOfDayUI")
			tod.visible = true
			Events.emit_signal("show_buttons_and_tod")
			GameManager.glPlayerRef._attempt_exit_store()
			get_viewport().set_input_as_handled()  # Mark event as handled
		
		if Input.is_action_just_pressed("activate"):
			var gen_str = find_anywhere("general_store")
			var tod = find_anywhere("TimeOfDayUI")
			gen_str.visible = true
			tod.visible = false
			Events.emit_signal("hide_buttons_and_tod")
			UiManager.active_ui = gen_str
			GameManager.glPlayerRef.state = Enum.State.SHOP
			get_viewport().set_input_as_handled()  # Mark event as handled



func is_player_interacting()->bool:
	return player_within_range


func interact():
	print("Store opening")

func _set_market_closed():
	if $interact_icon.visible:
		$interact_icon.visible = false

func _set_market_open():
	if !$interact_icon.visible:
		$interact_icon.visible = true





func interact_enabled(body: Node2D):
	if body.is_in_group("player"):
		Events.emit_signal("show_shop_icon")
		player_within_range = true
		plyr = body

func interact_disabled(body: Node2D):
	if body.is_in_group("player"):
		Events.emit_signal("hide_shop_icon")
		player_within_range = false
		plyr = body






func find_anywhere(name1: String) -> Node:
	var tree := get_tree()
	
	# 1. Try to get autoloads
	var autoloads = ProjectSettings.get_setting("application/config/autoloads")
	if autoloads != null:
		for autoload_name in autoloads.keys():
			var singleton = tree.get_first_node_in_group(autoload_name)
			if singleton:
				if singleton.name == name1:
					return singleton
				var found = singleton.find_child(name1, true)
				if found:
					return found

	# 2. Try current scene
	if tree:
		if tree.current_scene:
			var found = tree.current_scene.find_child(name1, true)
			if found:
				return found

	# 3. Try the root (includes autoloads + main viewport)
	return tree.root.find_child(name1, true, false)


# Bottom 
