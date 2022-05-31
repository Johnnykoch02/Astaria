extends Panel

signal item_engaged(slot, item)

onready var inventory_bar = self.get_parent()
var hovered: bool = false
var current_item = null
var slot_number: int

# Called when the node enters the scene tree for the first time.
func _ready():
	print('inside slot') # Replace with function body.
	connect("mouse_entered", self, "_on_mouse_entered")
	connect("mouse_exited", self, "_on_mouse_exited")
	
func _process(delta):
	if hovered:
#		if Input.is_action_just_pressed("ui_left_click"):
#			if inventory_bar.moving_item():
#				inventory_bar.transfer_item(self)
#			else:
#				inventory_bar.set_move_item(current_item)
#				make_empty()
#
		pass
func update_item(item):
		make_empty()
		current_item = item
		var world_item = current_item.item_reference
		var stack = Label.new()
		add_child(world_item)
		add_child(stack)
			
		var scale = Vector2(0.6,0.6)
#		world_item.set_scale(scale)
#		img.expand = true
#		img.rect_position = Vector2(19.2*index, 0)
#		img.set_texture(item.item_reference.item_data.inventoryTexture)
#		img.rect_min_size = Vector2(32,32) * scale	
		world_item.set_name(item.item_reference.item_data.name)
		world_item.set_scale(scale)
		world_item.set_position(Vector2(10,10))
			
		stack.rect_position = Vector2(12,12)
		stack.set_scale(scale)
		stack.set_name("quantity")
		stack.text = "x%d" % [item.quantity]
		
func make_empty():
	for child in get_children():
		remove_child(child)
# Replace with function body.
func swap(item):
	var swap_item = current_item
	update_item(item)
	return swap_item
	
func _on_mouse_entered():
	hovered = true

func _on_mouse_exited():
	hovered = false


