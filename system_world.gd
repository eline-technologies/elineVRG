
extends Spatial

# Member variables
var prev_pos = null
var last_click_pos = null

var holographicTcpServer = null

var dreamsCodeMode = true

func _ready():
	var args = OS.get_cmdline_args()
	if (args.size() > 0 and args[0] == "-vrgmode"):
		self.dreamsCodeMode = false
	
	if (not dreamsCodeMode):
		var interface = ARVRServer.find_interface("OVRMobile")
		if interface and interface.initialize():
			# Tell our viewport it is the arvr viewport:
			get_viewport().arvr = true
			get_viewport().hdr = false

		OS.vsync_enabled = false
		Engine.target_fps = 90
		var ovrPerformance = preload("res://addons/godot_ovrmobile/OvrPerformance.gdns").new()
		# enable the extra latency mode: this gives some performance headroom at the cost
		# of one more frame of latency
		ovrPerformance.set_extra_latency_mode(1); 
		# set fixed foveation level
		# for details see https://developer.oculus.com/documentation/quest/latest/concepts/mobile-ffr/
		ovrPerformance.set_foveation_level(4); 
		# if you want dynamic foveation make sure to set the maximum desired foveation with the previous function
		# before you enable dynamic foveation
		ovrPerformance.set_enable_dynamic_foveation(true);
	else:
		get_tree().change_scene("res://GUI.tscn")
		OS.set_window_title("DreamsCode")
