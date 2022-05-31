extends Node

signal player_initialized
var player = null
var player_ui = null
var camera: Camera2D

enum GameState {MENU, STORY, ARCADE} 
var Current_State = GameState.MENU

## MENU STATE VARIABLES


## STORY STATE VARIABLES


## ARCADE STATE VARIABLES

var current_round: int
var in_round:bool = false
var in_grace_period:bool = false
var total_round_entities: int
var current_round_entities: int
var Spawners =  Array()
var arcade_timer
var arcade_scene = load("res://Scenes/Arcade.tscn")

var world:Node2D



func _ready():
	print(load('res://Scenes/Menu.tscn'))
	print(arcade_scene)
	connect("entity_damaged", self, "damage_entity")

func _process(delta):
	match Current_State:
		GameState.MENU:
			pass
		GameState.STORY:
			pass
		GameState.ARCADE:
			arcade_process(delta)
	
	if not player:
		init_player()
		return
	if not camera:
		get_camera()
		

func get_camera():
	camera = get_tree().get_root().get_node("/root/Arcade/Camera2D")


func init_player():
	if Current_State!= GameState.MENU:
		world = get_tree().get_current_scene()
		if world:
			player = get_tree().get_current_scene().get_node("./Container/Player")
		
			if not player:
				return
			emit_signal("player_initialized", player)
	
			player.inventory.connect("inventory_changed", self, "_on_player_inventory_changed")
	
			var existing_inventory = load("user://user_inventory.tres")
			if existing_inventory:
				existing_inventory.get_items()
				player.inventory.set_items(existing_inventory.get_items())
			else:
				player.inventory.add_item("Pillager's Sword", 1)
	
func _on_player_inventory_changed(inventory):
	ResourceSaver.save("user://user_inventory.tres", inventory)
	
func damage_entity(victim, damager):
	victim.current_health -= damager.damage
	#statmanager - increment a stat based on which the player is
	
func consumable_used(consumable):
	pass
	
	
func has_parent(node, parent):
	var root = get_tree().get_root()
	while node != root:
		if node.name == parent:
			return true
		else:
			node = node.get_parent()
	return false
	
func init_arcade():
	#Put all spawners in our Spawners Var
	if world:
		for child in world.get_node("Container/Spawners").get_children():
			if child.name.begins_with("Spawner"):
				Spawners.append(child)
		current_round = 1
		arcade_timer = Timer.new()
		add_child(arcade_timer)
		arcade_timer.connect("timeout", self, "_on_grace_period_finished")
		get_camera()
		if not player_ui:
			player_ui = camera.get_node("UI")
		player_ui.enable_arcade_mode()
	

func start_round():
	player_ui.set_current_round(current_round)
	in_grace_period = true
	arcade_timer.start(10.0)
	world.get_node("RoundMusic").stop()
	world.get_node("GracePeriod").play()
	
func _on_grace_period_finished():
	arcade_timer.stop()
	total_round_entities = bat_spawn_number(current_round)
	current_round_entities = total_round_entities
	world.get_node("GracePeriod").stop()
	world.get_node("RoundMusic").play()
	var to_each = floor(total_round_entities/Spawners.size())
	var left_over = total_round_entities%Spawners.size()
	print("To Each: %s Left Over: %s" % [to_each, left_over])
	for spawner in Spawners:# Give to all the floor...
		spawner.spawn(to_each)
	for i in left_over: # Give the rest till we have no more.
		Spawners[i].spawn(1)
	in_grace_period = false
	in_round = true
	
func bat_spawn_number(current_round):
	if current_round > 1:
		return 3+3*(current_round-1)+(randi()%5-1)
	else:
	 return 3

func arcade_end():
	pass

### Processes

func arcade_process(delta):
	if Spawners.size() == 0:
		init_arcade()
	else:
		if in_round:
			#First Check Player Health
			player_ui.set_enemies_left(current_round_entities)
			var spawners_w_entities = 0
			for spawner in Spawners:
				if spawner.has_entities():
					spawners_w_entities+=1
			if spawners_w_entities == 0:
				in_round = false
				current_round+=1
		elif in_grace_period:
			pass
		else:
			start_round()
		
func get_relative_mouse_pos() -> Vector2:
	#You'll need to get mouse position - half of the game window size + the camera position.
	var global_pos = Vector2.ZERO
	global_pos.x = camera.global_position.x - (0.5*get_viewport().get_visible_rect().size.x)
	global_pos.y = camera.global_position.y - (0.5*get_viewport().get_visible_rect().size.y)	
	return global_pos + get_viewport().get_mouse_position()
