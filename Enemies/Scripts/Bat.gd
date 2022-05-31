extends KinematicBody2D

export var entity_name = "Bat"
signal entity_damaged(victim, damager)

export var total_health:float = 75.0
export var current_health:float = 75.0
export var damage:int = 23
onready var health_bar:ProgressBar = $Control/ProgressBar

var speed:float = 1.5
var acceleration:int = 8
var velocity:Vector2 = Vector2.ZERO
var displacement:Vector2 = Vector2.ZERO

onready var player:KinematicBody2D = GameManager.player
onready var effects_player:AnimatedSprite = $Effects
onready var entity_player:AnimatedSprite = $EntitySprite


func _ready():
	pass
	
func _physics_process(delta):
	if player:
		var displacement = player.global_position - global_position
		displacement = displacement.normalized()
		velocity.x += (displacement.x*speed*delta + displacement.x*acceleration*delta*delta + (((randi()%2)/2)-0.25)*delta)
		velocity.y += (displacement.y*speed*delta + displacement.y*acceleration*delta*delta + (((randi()%2)/2)-0.25)*delta)
		
		if velocity.length() > speed:
			velocity = velocity.normalized() * speed
			velocity.x += (displacement.x*speed*delta + displacement.x*acceleration*delta*delta + (((randi()%2)/2)-0.25)*delta)
			velocity.y += (displacement.y*speed*delta + displacement.y*acceleration*delta*delta +  (((randi()%2)/2)-0.25)*delta)
		
		move_and_collide(velocity)
	else: 
		player = GameManager.player

func _on_Hitbox_area_entered(area):
	#Checks to see  *REUSABLE
	if area != GameManager.player.get_node("Hurtbox") and GameManager.has_parent(area, "Player"):
		emit_signal("entity_damaged", self, area.Damager)
		velocity = velocity*acceleration*-1
		check_health()
	elif GameManager.has_parent(area, "Bat"):
		var diff = global_position - area.global_position
		velocity+= diff.normalized()/2
	
func check_health():
	
	if current_health < 0.0:
		effects_player.play("Death")
	else:
		effects_player.play("Damaged")
	var pct_health = (current_health/total_health)*100.0
	health_bar.value = pct_health
	if pct_health > 45.0:
		health_bar.set_modulate(Color("#a917ff15"))
	elif pct_health > 20.0:
		health_bar.set_modulate(Color("#a9f7ff00"))
	else:
		health_bar.set_modulate(Color("#a9ff0303"))
		
	



func _on_Effects_animation_finished():
	if current_health < 0:
		queue_free()
	effects_player.play("Base") # Replace with function body.
