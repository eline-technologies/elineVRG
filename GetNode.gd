extends GraphNode

onready var paramSelect = $ParamSelect
var selectParams
var selectedParam


# Called when the node enters the scene tree for the first time.
func _ready():
	refreshParamList(selectParams)

func refreshParamList(scriptParams):
	scriptParams = scriptParams
	paramSelect.clear()
	for i in scriptParams.size():
		paramSelect.add_item(scriptParams[i].name)
	selectParam(selectedParam)


func selectParam(paramName):
	for i in paramSelect.items.size():
		if paramSelect.get_item_text(i) == paramName:
			paramSelect.select(i)
