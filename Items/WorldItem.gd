extends Sprite

class_name World_Item

export var item_data: Resource
enum location {INVENTORY, WORLD, STORAGE}
export (location) var current_location



func _process(delta):
	if current_location == location.WORLD:
#		$Area2D/CollisionShape2D.set("disabled", false)
		pass
	else:
#		$Area2D/CollisionShape2D.set("disabled", true)
		pass
	if GameManager.has_parent(self, 'Camera2D'):
		current_location == location.INVENTORY
#	else if GameManager.has_parent(self, )
	else:
		current_location = location.WORLD
	reload_texture()

func _ready():
	if GameManager.has_parent(self, "Camera2D"):
		current_location == location.INVENTORY
#	else if GameManager.has_parent(self, )
	else:
		current_location = location.WORLD
	reload_texture()
	
	
func reload_texture():
		if item_data: # Replace with function body.
			if current_location == location.INVENTORY:
				self.set_texture(item_data.inventoryTexture)
			else:
				self.set_texture(item_data.worldTexture)
					
