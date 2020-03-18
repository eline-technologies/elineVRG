extends Camera

onready var SystemWorld = get_parent()

## Increase this value to give a slower turn speed
const CAMERA_TURN_SPEED = 700

func _ready():
	toggleVRMode()

func toggleVRMode():
	if (not SystemWorld.dreamsCodeMode):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		set_process_unhandled_input(true)

func look_updown_rotation(rotation = 0):
	"""
  Returns a new Vector3 which contains only the x direction
  We'll use this vector to compute the final 3D rotation later
	"""
	var toReturn = self.get_rotation() + Vector3(rotation, 0, 0)

	##
	## We don't want the player to be able to bend over backwards
	## neither to be able to look under their arse.
	## Here we'll clamp the vertical look to 90° up and down
	toReturn.x = clamp(toReturn.x, PI / -2, PI / 2)
	toReturn.y = SystemWorld.get_rotation().y
	return toReturn

func look_leftright_rotation(rotation = 0):
	"""
  Returns a new Vector3 which contains only the y direction
  We'll use this vector to compute the final 3D rotation later
	"""
	return SystemWorld.get_rotation() + Vector3(0, rotation, 0)

func mouse(event):
	"""
	First person camera controls
	"""
	##
	## We'll use the parent node "SystemWorld" to set our left-right rotation
	## This prevents us from adding the x-rotation to the y-rotation
	## which would result in a kind of flight-simulator camera
	SystemWorld.set_rotation(look_leftright_rotation(event.relative.x / -CAMERA_TURN_SPEED))
	##
	## Now we can simply set our y-rotation for the camera, and let godot
	## handle the transformation of both together
	self.set_rotation(look_updown_rotation(event.relative.y / -CAMERA_TURN_SPEED))

func _unhandled_input(event):
	##
	## We'll only process mouse motion events
	if event is InputEventMouseMotion:
		return mouse(event)
	
func _leave_tree():
	"""
	Show the mouse when we leave
	"""
	if (not SystemWorld.dreamsCodeMode):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
