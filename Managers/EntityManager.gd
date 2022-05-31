extends Node

func spawn_entity(container: Node, entity_name: String, pos: Vector2) -> KinematicBody2D:
	var entity = EntityDatabase.get_entity(entity_name)
	if entity:
		var newEntity = entity.instance()
		print("Entity: ", newEntity)
		container.add_child(newEntity)
		newEntity.global_position = pos
		newEntity.connect("entity_damaged", GameManager, "damage_entity")
		return newEntity
	return null
