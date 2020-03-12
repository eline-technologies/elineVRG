extends GraphNode


# Declare member variables here. Examples:
onready var graphEdit = get_parent()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	


func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	graphEdit.connect_node(from, from_slot, to, to_slot)
