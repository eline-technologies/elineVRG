extends GraphEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var eventNode = preload("res://EventNode.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("c:/Users/Padman/Documents/Projets/DreamsRT/src/test/resources/HelloWorldDreamsScript.vApp/Scripts/main.dreamsscript", File.READ)
	var content = file.get_as_text()
	var script = JSON.parse(content).result
	file.close()
	for i in script.methods.size():
		if script.methods[i].name == "#_init":
			loadDreamScriptMethod(script.methods[i])

func loadDreamScriptMethod(scriptMethod):
	var beginNode = eventNode.instance()
	beginNode.title = "OnBegin"
	beginNode.offset = Vector2(scriptMethod.x,scriptMethod.y)
	self.add_child(beginNode)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
