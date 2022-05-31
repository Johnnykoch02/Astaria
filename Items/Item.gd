extends Resource

class_name ItemResource

export var name : String
export var stackable : bool = false
export var max_stack_size : int = 1
export var damage : float = 0
export var hitbox : String = ''
export var stat_level : int = 1
export var status_target: String = ''
export var status_modifier: int = 0
export var ItemScene: Resource
enum ItemType {GENERIC, CONSUMABLE, ALCHEMY, QUEST, EQUIPMENT, BUILD, MONETARY}
export (ItemType) var type

export var worldTexture : Texture
export var inventoryTexture : Texture

export var itemScript : Script
