extends GraphEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var paramItem = preload("res://ScriptParamItem.tscn")
onready var eventNode = preload("res://EventNode.tscn")
onready var getNode = preload("res://GetNode.tscn")
onready var ifNode = preload("res://IfNode.tscn")
onready var printTextNode = preload("res://PrintTextNode.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = File.new()
	file.open("res://HelloWorldDreamsScript.vApp/Scripts/main.dreamsscript", File.READ)
	var content = file.get_as_text()
	var script = JSON.parse(content).result
	file.close()
	loadScriptParams(script.params)
	for i in script.methods.size():
		if script.methods[i].name == "#_init":
			loadDreamScriptMethod(script.methods[i])

func loadDreamScriptMethod(scriptMethod):
	var beginNode = eventNode.instance()
	beginNode.title = "OnBegin"
	beginNode.offset = Vector2(scriptMethod.x,scriptMethod.y)
	self.add_child(beginNode)
	loadMethodNodes(scriptMethod)

func loadMethodNodes(scriptMethod):
	for i in scriptMethod.nodes.size():
		var node = scriptMethod.nodes[i]
		var newNode
		if node.node_type == "Get":
			newNode = getNode.instance()
		elif node.node_type == "If":
			newNode = ifNode.instance()
		elif node.node_type == "PrintText":
			newNode = printTextNode.instance()
		newNode.offset = Vector2(node.x, node.y)
		self.add_child(newNode)

func loadScriptParams(scriptParams):
	var paramList = get_tree().get_root().find_node("ParamsList", true, false)
	var addParamBtn = get_tree().get_root().find_node("AddParamButton", true, false)
	for i in scriptParams.size():
		var param = scriptParams[i]
		var newParamItem = paramItem.instance()
		paramList.add_child(newParamItem)
		paramList.move_child(addParamBtn, paramList.get_child_count()-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
