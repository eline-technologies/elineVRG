extends OptionButton


var selectedType = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	self.add_item("bool", 0)
	self.add_item("int", 1)
	self.add_item("string", 2)
	self.selected = selectedType


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TypeSelect_item_selected(id):
	if id == 0:
		get_parent().setParamValue(self.text, false)
	elif id == 1:
		get_parent().setParamValue(self.text, 0)
	elif id == 2:
		get_parent().setParamValue(self.text, "")
