extends Node2D

var entities = Array()

func _ready():
	pass 

func spawn(total, type="Bat"):
	for i in total:
		print("Spawning a bat")
		var spawn_pos = Vector2(global_position.x+randi()%10 - 5, global_position.y+randi()%10 - 5)
		entities.append(EntityManager.spawn_entity(self, type, spawn_pos))
		
func _process(delta):
		if entities.size() > 0:
			for i in entities.size(): 
				var ref = weakref(entities[i])
				if !ref.get_ref(): # checks to see if the node is still referencable ( Not Deleted )
					entities.remove(i)
					GameManager.current_round_entities-=1
					return
					
func has_entities()->bool:
	return !entities.empty()
					
			
