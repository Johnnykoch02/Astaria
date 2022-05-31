extends Resource
class_name Inventory

signal inventory_changed
var inv_size:int = 9
var slots_open:int

export var _items = Array() setget set_items, get_items # MAkes sure items dont get deleted
func set_items(new_items):
	_items = new_items
	emit_signal("inventory_changed", self)
	
func get_items():
	return _items
	
func get_item(index):
	return _items[index]
	
func remove_item(index):
	_items.remove(index)
	emit_signal("inventory_changed", self)

func add_item(item_name, quantity):
	
	if quantity <=0:
		print("Cannot add Negative number of items.")
		return
	print("Adding 1")
	var item = ItemDataBase.get_item(item_name)
	if not item:
		print('Item not in Database.')
		return
	print("Adding 2")
	var remaining_quantity = quantity
	var max_stack_size = item.item_data.max_stack_size if item.item_data.stackable else 1
	
	if item.item_data.stackable:
		for i in range(_items.size()):
			if remaining_quantity == 0:
				break
			var inventory_item = _items[i]
			
			if inventory_item.item_reference.name != item.name:
				continue
			
			if inventory_item.quantity < max_stack_size:
				var original_quantity = inventory_item.quantity
				inventory_item.quantity = min(original_quantity + remaining_quantity, max_stack_size)
				remaining_quantity -= inventory_item.quantity - original_quantity
				
	while remaining_quantity > 0:	
		var new_item = {
			slot = -1,
			item_reference = item, 
			quantity = min(remaining_quantity, max_stack_size)
		}
		_items.append(new_item)
		remaining_quantity -= new_item.quantity
		print("Adding last")
	emit_signal("inventory_changed", self)
			
func transfer_item(item_move, slot, grid):
	item_move.slot = slot.slot_number
	if slot.current_item: #!= empty_item
		grid.set_move_item(slot.swap(item_move))
		
	else:
		slot.update_item(item_move)
		grid.set_move_item(null)
		grid.set_item_sprite(null)

	emit_signal("inventory_changed")
	print("Moving Item!")


func sort_inv():
	pass
	
func _process():
	slots_open = inv_size - _items.size()
