extends Camera2D
var player = null

var cam_acceleration = 100
# Target position is player position
var cam_velocity = 20
var camera_target = null

func _ready():
	#var delta_pos = $position - 
	player = get_parent().get_node("Container/Player")
	print("Player: ", player) # Replace with function body.
	camera_target = player


func _process(delta):
	# get the vector
	if camera_target:
		var delta_pos = position - camera_target.get_position()
		#Normalize it so we know our direction
		var dp = delta_pos.normalized()
		#Move camera in that direcrion
		if delta_pos.length() > 1.0:
			position.x += -dp.x*cam_velocity*delta - delta_pos.x*cam_acceleration*delta*delta
			position.y += -dp.y*cam_velocity*delta - delta_pos.y*cam_acceleration*delta*delta

#		position = camera_target.get_position()
func set_target(new_target):
	camera_target = new_target

func get_target():
	return camera_target


	
