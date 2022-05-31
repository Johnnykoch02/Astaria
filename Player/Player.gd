extends KinematicBody2D

var input_axis:Vector2 = Vector2(0,0)
var velocity:Vector2 = Vector2(0,0)
export var speed:int = 25
var speed_mod:int = 0 
var roll_cooldown:float = 0.0
var item_cooldown:float = 0.0
export var target_cooldown:float = 0.5
var player_state = []

export var total_health:float = 120.0
export var current_health:float = 120.0
onready var health_bar:ProgressBar = $Control/ProgressBar
onready var health_display:Label = $Control/HealthDisplay
var knockback:Vector2 = Vector2.ZERO

var UI = null
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")

#Signals
signal entity_damaged(victim, damager)

var delta:float = 0.0

enum  {MOVE, ITEM_USE, ROLL, INVENTORY, DAMAGED}
var state:int = MOVE

var inventory_resource = load("res://Player/Inventory.gd")
var inventory:Resource = inventory_resource.new()
var current_inventory_slot:int = 1
export var currently_equipped_item : Resource

func _ready():
	print("Initialized.")
	animation_tree.active = true
	connect("entity_damaged", GameManager, "damage_entity")
	print(UI)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(del):
	delta = del	
	roll_cooldown-=delta
	item_cooldown-=delta
	#We Want to Push a move process every time
	# Add in process for Item_Press
	if(Input.is_action_just_pressed("ui_inventory")):
		if not UI:
			UI = GameManager.camera.get_node("UI")
		UI.toggle_inventory()
		if state == INVENTORY:
			state = MOVE
		else:
			state = INVENTORY
	elif(Input.is_action_just_pressed("ui_item_use") or state == ITEM_USE):
		player_state.push_front("item_process")
		
	elif(Input.is_action_just_pressed("ui_roll") or state == ROLL):
		player_state.push_front("roll_process")
	elif(state == DAMAGED):
		player_state.push_front("knockback_process")
	else:
		player_state.push_front("move_process")
	
	if UI:
		if UI.get_toggle():
			state == INVENTORY
	while not player_state.empty():
		var ref = funcref(self, player_state.pop_front())
		ref.call_func()
	
		
	#move_process()
	
#Item_Interaction State
func anim_roll():
	animation_player.set_speed_scale(1.0 + 0.5*speed_mod) if input_axis!= Vector2.ZERO else animation_player.set_speed_scale(1.0)
	animation_state.travel("Roll")

func roll_process():
	if roll_cooldown<=0.0:
		if state != ROLL:
			anim_roll()
			state = ROLL	
		move_and_collide(velocity*speed*delta*2.0*(1.0 + 0.5*speed_mod))

func anim_item(item):
	animation_state.travel("Item")
	
func item_process():
	if item_cooldown<=0.0:
		anim_item(null)
		state = ITEM_USE

# MOVE STATE
func anim_move():
	# Set Playback Scale based on the speedmod index
	animation_player.set_speed_scale(1.0 + 0.5*speed_mod) if input_axis!= Vector2.ZERO else animation_player.set_speed_scale(1.0)
	animation_player.set_speed_scale(1.0 + 0.5*speed_mod) if input_axis!= Vector2.ZERO else animation_player.set_speed_scale(1.0)
	#IDLE Animations
	input_axis.y *=-1
	if input_axis != Vector2.ZERO:
		update_tree_parameters()
	else:
		animation_state.travel("Idle")	

func move_process():
	if state== MOVE:
		input_axis.y = -1 * get_axis("ui_down", "ui_up")
		input_axis.x =1* get_axis("ui_left", "ui_right")
		speed_mod = 1*get_axis("ui_crouch", "ui_sprint")
		input_axis = input_axis.normalized()
		# Upate Velocity Vector: Set our Speed				Modify it based on the speed modifier axis
		velocity.x = speed*delta*input_axis.x + velocity.x*0.5 + speed_mod*0.7*speed*delta*input_axis.x
		velocity.y = speed*delta*input_axis.y + velocity.y*0.5 + speed_mod*0.7*speed*delta*input_axis.y 
		#update animation player
		anim_move()
		move_and_collide(velocity)
	else:
		move_and_collide(Vector2.ZERO)
		
func knockback_process():
	move_and_collide(knockback)
				
func toggle_busy():
	if state == ROLL:
		roll_cooldown = target_cooldown
		item_cooldown = target_cooldown/2
	elif state == ITEM_USE:
		roll_cooldown = target_cooldown/2
		item_cooldown = target_cooldown		
	state = MOVE
	$Sprite.modulate = Color("#ffffff")
	
func get_speed_mod():
	return speed_mod
	
func get_axis(neg, pos):
	return Input.get_action_strength(pos) - Input.get_action_strength(neg)
	
func update_tree_parameters():
	animation_tree.set("parameters/Item/blend_position", input_axis)
	animation_tree.set("parameters/Idle/blend_position", input_axis)
	animation_tree.set("parameters/Run/blend_position", input_axis)	
	animation_tree.set("parameters/Roll/blend_position", input_axis)	
	animation_tree.set("parameters/Damaged/blend_position", input_axis)
	animation_state.travel("Run")
	


func _on_Hurtbox_area_entered(area: Area2D):
	var entity = EntityDatabase.get_entity(area.get_parent().entity_name)
	if entity and state != DAMAGED:
		emit_signal("entity_damaged", self, area.get_parent())# Replace with function body.
		player_damaged(area)

func is_target():
	return self == GameManager.camera.get_target()
	
func player_damaged(area: Area2D):
	animation_state.travel("Damaged")
	state = DAMAGED
	check_health()
	knockback = global_position - area.global_position
	knockback  = knockback.normalized()
	knockback*= area.get_parent().velocity.length()*speed*delta

func check_health():
	var pct_health = (current_health/total_health)*100.0
	health_bar.value = pct_health
	health_display.text = "%s/%s" %[int(current_health),int(total_health)]
	if pct_health > 45.0:
		health_bar.set_modulate(Color("#a917ff15"))
	elif pct_health > 20.0:
		health_bar.set_modulate(Color("#a9f7ff00"))
	else:
		health_bar.set_modulate(Color("#a9ff0303"))	


func _on_InteractionSphere_area_entered(area):
	var item_data = area.get_parent().get("item_data")
	if item_data:
		inventory.add_item(item_data.name, 1)
