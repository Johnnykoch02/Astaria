extends Control

var labels = []
var current = 0 
var input_axis = 0
onready var scenes = [null, null, GameManager.arcade_scene]

func _ready():
	labels.append(get_node("VideoPlayer/MainMenu/CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer2/CenterContainer/HBoxContainer/1"))
	labels.append(get_node("VideoPlayer/MainMenu/CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer2/CenterContainer2/HBoxContainer/2"))
	labels.append(get_node("VideoPlayer/MainMenu/CenterContainer/VBoxContainer/CenterContainer2/VBoxContainer2/CenterContainer3/HBoxContainer/3"))
	$AudioStreamPlayer.play() 
	
func _process(delta):
	input_axis = -1*get_axis("ui_down", "ui_up")
	if input_axis == 1:
		if current < 2:
			labels[current].set_visible(false)
			current+=1
			labels[current].set_visible(true)
	elif input_axis == -1:
		if current > 0:
			labels[current].set_visible(false)
			current-=1
			labels[current].set_visible(true)
	if(Input.is_action_just_pressed("ui_enter")):
		print(current)
		match current:
			0:
				pass
			1:
				pass
			2:
				GameManager.Current_State = GameManager.GameState.ARCADE
		get_tree().change_scene_to(scenes[current])
		
		print(scenes[current])
	
func _on_VideoPlayer_finished():
	$VideoPlayer.play() 


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.play() 

func get_axis(neg, pos):
	if Input.is_action_just_pressed(neg):
		return -1
	elif Input.is_action_just_pressed(pos):
		return 1
	return 0
