extends Node

var entities = Dictionary()

func _ready():
	var dir = Directory.new()
	dir.open("res://Enemies/Scenes/")
	dir.list_dir_begin()
	
	var filename = dir.get_next()
	
	while(filename):
		if not dir.current_is_dir():
			var path = "res://Enemies/Scenes/" + filename
			var entity = filename.split('.')[0]
			entities[entity] = load("res://Enemies/Scenes/%s" % filename)
		filename = dir.get_next()
		
func get_entity(entity_name: String) -> PackedScene:
	return entities[entity_name]

func get_entities() -> Array:
	return entities
