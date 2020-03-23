extends GraphEdit

onready var paramItem = preload("res://ScriptParamItem.tscn")
onready var eventNode = preload("res://EventNode.tscn")
onready var getNode = preload("res://GetNode.tscn")
onready var ifNode = preload("res://IfNode.tscn")
onready var printTextNode = preload("res://PrintTextNode.tscn")
onready var scriptTitle = self.find_node("ScriptTitle")

var appScript

# Called when the node enters the scene tree for the first time.
func _ready():
	loadAppScript("res://HelloWorldDreamsScript.vApp")

func loadAppScript(appPath):
	var filename = appPath + "/Scripts/main.dreamsscript"
	var file = File.new()
	if file.file_exists(filename):
		file.open(filename, File.READ)
		var content = file.get_as_text()
		appScript = JSON.parse(content).result
		file.close()
		scriptTitle.text = getAppName(appPath) + " - " + appScript.name
		loadScriptParams(appScript.params)
		for i in appScript.methods.size():
			if appScript.methods[i].name == "#_init":
				loadDreamScriptMethod(appScript.methods[i], appScript.params)

func getAppName(appPath):
	var tmp = appPath.split('/')
	return tmp[tmp.size()-1]

func loadScriptParams(scriptParams):
	var paramList = get_tree().get_root().find_node("ParamsList", true, false)
	var addParamBtn = get_tree().get_root().find_node("AddParamButton", true, false)
	for i in scriptParams.size():
		var param = scriptParams[i]
		var newParamItem = paramItem.instance()
		newParamItem.loadParam(param)
		paramList.add_child(newParamItem)
		paramList.move_child(addParamBtn, paramList.get_child_count()-1)

func loadDreamScriptMethod(scriptMethod, scriptParams):
	var beginNode = eventNode.instance()
	beginNode.title = "OnBegin"
	beginNode.offset = Vector2(scriptMethod.x,scriptMethod.y)
	self.add_child(beginNode)
	loadMethodNodes(scriptMethod, scriptParams)

func loadMethodNodes(scriptMethod, scriptParams):
	for i in scriptMethod.nodes.size():
		var node = scriptMethod.nodes[i]
		var newNode
		if node.node_type == "Get":
			newNode = getNode.instance()
			newNode.selectedParam = node.param_name
			newNode.selectParams = scriptParams
		elif node.node_type == "If":
			newNode = ifNode.instance()
		elif node.node_type == "PrintText":
			newNode = printTextNode.instance()
		newNode.offset = Vector2(node.x, node.y)
		self.add_child(newNode)

func addNewParam(name, type, scope, value):
	var newParam = {
		"name": name,
		"scope": scope,
		"type": type,
		"value": value
	}
	appScript.params.append(newParam)
	var children = self.get_children()
	for i in children.size():
		var child = children[i]
		if child is preload("GetNode.gd"):
			child.refreshParamList(appScript.params)

func removeParam(param):
	var index = 0
	for idx in appScript.params.size():
		if appScript.params[idx].name == param.name:
			index = idx
	appScript.params.remove(index)
	var children = self.get_children()
	for i in children.size():
		var child = children[i]
		if child is preload("GetNode.gd"):
			child.refreshParamList(appScript.params)

#func editParam(param):
#	var index = 0
#	for idx in appScript.params.size():
#		if appScript.params[idx].name == param.name:
#

func _on_GraphEdit_connection_request(from, from_slot, to, to_slot):
	if from_slot == 0 and to_slot == 0:
		self.connect_node(from, from_slot, to, to_slot)
	elif from_slot != 0 and to_slot != 0:
		self.connect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_disconnection_request(from, from_slot, to, to_slot):
	self.disconnect_node(from, from_slot, to, to_slot)
