extends Control

onready var inventory_bar = $Panel/InventoryBar

func _ready():
	pass
	
func enable_arcade_mode():
	$ArcadeMode.set_visible(true)

func disable_arcade_mode():
	$ArcadeMode.set_visible(false)

func enable_story_mode():
	$StoryMode.set_visible(true)

func disable_story_mode():
	$StoryMode.set_visible(false)
	
### Arcade Mode Setters

func set_current_round(num):
	$ArcadeMode/Container/Panel/VBoxContainer/CurrentRound.set_text("Round: %s" % num)
	
func set_enemies_left(num):
	$ArcadeMode/Container/Panel/VBoxContainer/EnemiesLeft.set_text("Enemies Left: %s" % num)

