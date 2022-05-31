extends Node2D

var finished = true
var animation_node = null


func _ready():
	animation_node = get_node("AnimatedSprite")




func _on_AnimatedSprite_animation_finished():
	animation_node.play("Nothing")# Replace with function body.


func _on_Grass_body_entered(body):
	if body == GameManager.player or body.get_parent().get_parent().get_parent() == GameManager.player:
		animation_node.play("Ruffle")
		animation_node.set_speed_scale(1.0 + 0.5*GameManager.player.get_speed_mod())
