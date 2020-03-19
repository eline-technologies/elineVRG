
extends Spatial

# Member variables
var prev_pos = null
var last_click_pos = null
var viewport = null

var holographicTcpServer = null

var dreamsCodeMode = true

func _input(event):
	if (not dreamsCodeMode):
		# Check if the event is a non-mouse event
		var is_mouse_event = false
		var mouse_events = [InputEventMouseButton, InputEventMouseMotion, InputEventScreenDrag, InputEventScreenTouch]
		for mouse_event in mouse_events:
			if (event is mouse_event):
				is_mouse_event = true
				break
  
		# If it is, then pass the event to the viewport
		if (is_mouse_event == false):
			viewport.input(event)


# Mouse events for Area
func _on_area_input_event(camera, event, click_pos, click_normal, shape_idx):
	if (not dreamsCodeMode):
		# Use click pos (click in 3d space, convert to area space)
		var pos = get_node("Area").get_global_transform().affine_inverse()
		# the click pos is not zero, then use it to convert from 3D space to area space
		if (click_pos.x != 0 or click_pos.y != 0 or click_pos.z != 0):
			pos *= click_pos
			last_click_pos = click_pos
		else:
			# Otherwise, we have a motion event and need to use our last click pos
			# and move it according to the relative position of the event.
			# NOTE: this is not an exact 1-1 conversion, but it's pretty close
			pos *= last_click_pos
			if (event is InputEventMouseMotion or event is InputEventScreenDrag):
				pos.x += event.relative.x / viewport.size.x
				pos.y += event.relative.y / viewport.size.y
				last_click_pos = pos
	  
		# Convert to 2D
		pos = Vector2(pos.x, pos.y)
	  
		# Convert to viewport coordinate system
		# Convert pos to a range from (0 - 1)
		pos.y *= -1
		pos += Vector2(1, 1)
		pos = pos / 2
	  
		# Convert pos to be in range of the viewport
		pos.x *= viewport.size.x
		pos.y *= viewport.size.y
		
		# Set the position in event
		event.position = pos
		event.global_position = pos
		if (prev_pos == null):
			prev_pos = pos
		if (event is InputEventMouseMotion):
			event.relative = pos - prev_pos
		prev_pos = pos
		
		# Send the event to the viewport
		viewport.input(event)


func _ready():
	var args = OS.get_cmdline_args()
	if (args.size() > 0 and args[0] == "-vrgmode"):
		self.dreamsCodeMode = false
		var camera = get_node("Camera")
		camera.toggleVRMode()
		var raycast = camera.get_child(0)
		raycast.toggleVRMode()
	
	if (not dreamsCodeMode):
		var interface = ARVRServer.find_interface("OVRMobile")
		if interface and interface.initialize():
			# Tell our viewport it is the arvr viewport:
			get_viewport().arvr = true
			# change our physics fps
			Engine.target_fps = 72
		OS.set_window_size(Vector2(1920, 1080))
		OS.window_fullscreen = true
		viewport = get_node("Viewport")
		var gui = get_node("GUI")
		self.remove_child(gui)
		viewport.add_child(gui, true)
		get_node("Area").connect("input_event", self, "_on_area_input_event")
		var projectResolution=Vector2(OS.get_window_size())
		get_node("aim_point").global_position = Vector2(projectResolution.x / 2, projectResolution.y / 2)
	else:
		OS.set_window_title("DreamsCode")
		get_node("aim_point").visible = false
