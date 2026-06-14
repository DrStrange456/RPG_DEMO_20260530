class_name UIManager
extends Node

var inv_scene = preload("res://scenes/UI/PlayerInventory_UI.tscn")
var pause_scene = preload("res://scenes/UI/new_pause_screen.tscn")
var gen_str_scene = preload("res://scenes/levels/new_general_store.tscn")
#var gen_str_scene = preload("res://scenes/UI/general_store.tscn")

var current_window: Control = null

#@onready var inventory_window = $InventoryWindow
var inventory_open := false
var current_tween: Tween

var active_sell_ui: bool
var active_ui


# Set these in _ready() after positioning your UI
#var open_position: Vector2 = Vector2(-56,-134)
#var closed_position: Vector2 = Vector2(-56,308)



func _ready():
#	Even though scene is paused, still accept input from UI
	process_mode = Node.PROCESS_MODE_ALWAYS



func _unhandled_input(event):
	if event.is_action_pressed("mapped_quick_open_inventory"):
		#open_inventory()
		pass
	elif event.is_action_pressed("mapped_quick_open_character"):
		open_character()
	elif event.is_action_pressed("ui_cancel"):
		close_current_window()
	elif event.is_action_pressed("open_pause"):
		#open_pause()
		pass
	elif event.is_action_pressed("activate"):
		#open_general_store()
		pass






func open_inventory():
	close_current_window()
	
	var window_container: Node2D = find_anywhere("WindowContainer")
	
	current_window = inv_scene.instantiate()
	window_container.add_child(current_window)
	
	await get_tree().process_frame
	
	current_window = current_window.find_child("INVENTORYUI",true)
	
	# Make sure the window scales from its center
	#current_window.pivot_offset = current_window.size / 2.0
	
	# Initial state
	current_window.visible = true
	current_window.scale = Vector2(0.8, 0.8)
	current_window.modulate.a = 0.0
	
	var tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		current_window,
		"scale",
		Vector2.ONE,
		0.2
	)
	
	tween.tween_property(
		current_window,
		"modulate:a",
		1.0,
		0.2
	)
	
	get_tree().paused = true
	inventory_open = true

func open_pause():
	close_current_window()
	
	var window_container: Node2D = find_anywhere("WindowContainer")
	
	current_window = pause_scene.instantiate()
	window_container.add_child(current_window)
	
	await get_tree().process_frame
	
	# Make sure the window scales from its center
	current_window.pivot_offset = current_window.size / 2.0
	
	# Initial state
	current_window.visible = true
	current_window.scale = Vector2(0.8, 0.8)
	current_window.modulate.a = 0.0
	
	var tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		current_window,
		"scale",
		Vector2.ONE,
		0.2
	)
	
	tween.tween_property(
		current_window,
		"modulate:a",
		1.0,
		0.2
	)
	
	get_tree().paused = true
	inventory_open = true

func close_current_window():
	if current_window == null:
		return

	var tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(
		current_window,
		"scale",
		Vector2(0.8, 0.8),
		0.2
	)

	tween.tween_property(
		current_window,
		"modulate:a",
		0.0,
		0.2
	)

	await tween.finished

	current_window.queue_free()
	current_window = null

	get_tree().paused = false
	inventory_open = false

func open_character():
	pass

func open_general_store():
	close_current_window()
	
	var window_container: Node2D = find_anywhere("WindowContainer")
	
	current_window = gen_str_scene.instantiate()
	window_container.add_child(current_window)
	
	await get_tree().process_frame
	
	# Make sure the window scales from its center
	current_window.pivot_offset = current_window.size / 2.0
	
	# Initial state
	current_window.visible = true
	current_window.scale = Vector2(0.8, 0.8)
	current_window.modulate.a = 0.0
	
	var tween = create_tween()
	tween.set_parallel()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(
		current_window,
		"scale",
		Vector2.ONE,
		0.2
	)
	
	tween.tween_property(
		current_window,
		"modulate:a",
		1.0,
		0.2
	)
	
	get_tree().paused = true
	inventory_open = true




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
