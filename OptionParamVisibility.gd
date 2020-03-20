extends OptionButton


var selectedScope = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_item("private", 0)
	self.add_item("protected", 1)
	self.add_item("public", 2)
	self.selected = selectedScope


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
