extends RayCast

var ray = null
var viewport = null
var prev_pos = null
var last_click_pos = null

func _ready():
	ray = self
	viewport = get_parent().get_parent().get_node("Viewport")
	##set_process_input(true)

func _input(event):
	##
	## We'll only process mouse motion events
	if event is InputEventMouseMotion or event is InputEventMouseButton:
		if viewport != null and ray.is_enabled() and ray.is_colliding():
			
			var collided = ray.get_collider()
			var collisionPoint = ray.get_collision_point()

			# Use click pos (click in 3d space, convert to area space)
			var pos = get_parent().get_parent().get_node("Area").get_global_transform().affine_inverse()

			# Otherwise, we have a motion event and need to use our last click pos
			# and move it according to the relative position of the event.
			# NOTE: this is not an exact 1-1 conversion, but it's pretty close
			pos *= collisionPoint
			if (event is InputEventMouseMotion or event is InputEventScreenDrag):
				pos.x += event.relative.x / viewport.size.x
				pos.y += event.relative.y / viewport.size.y
		  
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
	
