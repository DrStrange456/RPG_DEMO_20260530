extends Control


@onready var main_inventory_container_ui: GridContainer = $INVENTORYUI/MainInventoryController
var inventory : Array[OptiInventorySlot] = []


func _ready() -> void:
	Events.connect("refresh_market_inv_ui", Callable(_refresh_inventory_items))
	_load_slots_from_save()


func bind_inventory(inv):
	var ui_slots = main_inventory_container_ui.get_children()
	for i in ui_slots.size():
		ui_slots[i].bind_slot(inv[i])


func _load_slots_from_save():
	inventory.resize(GameManager.PLAYER_INVENTORY_TEST.size())
	for i in inventory.size():
		inventory[i] = OptiInventorySlot.new()
	
	bind_inventory(inventory)
	
	for j in GameManager.PLAYER_INVENTORY_TEST:
		for i in main_inventory_container_ui.get_child_count():
			main_inventory_container_ui._set_slot(i)
		if GameManager.PLAYER_INVENTORY_TEST[j][0] != null:
			if int(GameManager.PLAYER_INVENTORY_TEST[j][1]) > 0:
				inventory[j].indx = j
				inventory[j].set_item(load(GameManager.PLAYER_INVENTORY_TEST[j][0]))
				inventory[j].set_quantity(GameManager.PLAYER_INVENTORY_TEST[j][1])


func _on_btn_sort_inv_pressed() -> void:
	StorageManager.sort_and_combine_inventory_Inv(GameManager.PLAYER_INVENTORY_TEST)
	AudioController.play_sound("sfx_slots_reorder")
	_refresh_inventory_items()

func _refresh_inventory_items():
	_load_slots_from_save()
