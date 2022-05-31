extends Node

var items = Array()

func _ready():
	var dir = Directory.new()
	dir.open("res://Items/Scenes")
	dir.list_dir_begin()
	
	var filename = dir.get_next()
	
	while(filename):
		if not dir.current_is_dir():
			var scene = load("res://Items/Scenes/%s" % filename)
			items.append(scene)
		filename = dir.get_next()
		
func get_item(item_name: String) -> World_Item:
	print("Adding 0")
	for item in items:
		if item.instance().item_data.name == item_name:
			return item.instance()
	return null
