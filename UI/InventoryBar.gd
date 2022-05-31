extends GridContainer

onready var slots: = get_children()
onready var animator = self.get_parent().get_node("AnimationPlayer")
var item_move = null
var item_sprite = null

func _ready():
	GameManager.connect("player_initialized", self, "_on_player_initialized")
	if not slots:
		slots = get_children()
	var index:int = 0
	for slot in slots:
		slot.slot_number = index
		index+=1
		
func _process(delta):
	if item_sprite:
		item_sprite.global_position = GameManager.get_relative_mouse_pos()
	if item_move!=null and item_sprite==null:
		item_sprite  = item_move.item_reference
		add_child(item_sprite)
		item_sprite.set_scale(Vector2(0.2,0.2))
		item_sprite.set_name("MovingItemSprite")
		
	if Input.is_action_just_pressed("ui_left_click"):
		var slot_hovered = null
		for slot in slots:
			if slot.hovered:
				slot_hovered = slot
				print("Broken For Loop")
				break
		print("HIIIIII")
		if slot_hovered:
			if moving_item():
				if slot_hovered.get_children().size() > 0:
					item_move = slot_hovered.swap(item_move)
				slot_hovered.make_empty()
				transfer_item(slot_hovered)
			else:
				set_move_item(slot_hovered.current_item)
				slot_hovered.make_empty()
		else:
			pass
	
func _on_player_initialized(player):
	player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	
func _on_player_inventory_changed(inventory):
	for slot in get_children():
		if slot.name.begins_with("Slot"):
			slot.make_empty()
	if slots:
		for item in inventory.get_items():
			if item.slot <0:
				if available_slots().size() > 0:
					item.slot = available_slots()[0].slot_number
			var current_slot = slots[item.slot]
			current_slot.update_item(item)
		
func set_move_item(item):
	self.item_move = item

func moving_item():
	return self.item_move != null

func transfer_item(slot):
	GameManager.player.inventory.transfer_item(item_move, slot, self)
func available_slots()-> Array:
	var available = Array()
	for slot in slots:
		if slot.get_children().size() == 0:
			available.append(slot)
	return available
	
func inventory_full():
	return available_slots().size() == 0

func set_item_sprite(setter):
	item_sprite = setter
