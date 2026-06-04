class_name UIManager
extends Node

var active_ui: Node = null
var active_sell_ui: bool = false

func _ready():
#	Even though scene is paused, still accept input from UI
	process_mode = Node.PROCESS_MODE_ALWAYS
	#print("UI Manager ready at: ", Time.get_ticks_msec())


func _input(event: InputEvent) -> void:
	#if event is InputEventMouseButton:
	if event is InputEventKey:
		if Input.is_action_just_pressed("activate"):
			var pause_screen: Control = find_anywhere("PauseScreen")
			var gen_str: Control = find_anywhere("general_store")
			var mrkt: Node2D = find_anywhere("market")
			
			if active_ui != pause_screen and active_ui != gen_str:
				if mrkt.is_player_interacting():
					print("opening general store")
				
		if event.is_action_pressed("mapped_quick_open_inventory"):
			var pause_screen: Control = find_anywhere("PauseScreen")
			var gen_str: Control = find_anywhere("general_store")
			
			if active_ui != pause_screen and active_ui != gen_str:
				# Player activated pause screen from No UI shown
				get_tree().paused = true
				pause_screen.visible = true
				active_ui = pause_screen
				pause_screen._quick_load_inventory()
				return
		if event.is_action_pressed("ui_cancel"):
			var pause_screen: Control = find_anywhere("PauseScreen")
			var gen_str: Control = find_anywhere("general_store")
			var tod = find_anywhere("TimeOfDayUI")
			
			if active_ui:
				if active_ui.is_in_group("storage_chests"):
					# Handle Storage Chest UIs
					return_to_default_ui() 
					var storage = find_anywhere("Storage_Bin")
					for N in storage.get_children():
						N.visible = false  
					return
			
			if active_ui != pause_screen and active_ui != gen_str:
				# Player activated pause screen from No UI shown
				get_tree().paused = true
				pause_screen.visible = true
				tod.visible = true
				active_ui = pause_screen
				pause_screen._quick_load_default()
				return
			
			return_to_default_ui()



func return_to_default_ui():
	var pause_screen: Control = find_anywhere("PauseScreen")
	var tod = find_anywhere("TimeOfDayUI")
	
	get_tree().paused = false
	pause_screen.visible = false
	tod.visible = true
	active_ui = null
	Events.emit_signal("update_weapon_button")
	Events.emit_signal("update_tool_button")
	Events.emit_signal("update_item_button")





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
