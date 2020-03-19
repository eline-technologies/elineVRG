extends Button

onready var paramItem = preload("res://ScriptParamItem.tscn")
onready var ParamList = get_parent()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_AddParamButton_pressed():
	var newParam = paramItem.instance()
	ParamList.add_child(newParam)
	ParamList.move_child(self, ParamList.get_child_count()-1)
