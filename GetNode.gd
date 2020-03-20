extends GraphNode

onready var paramSelect = $ParamSelect
var selectedParam
var scriptParams


# Called when the node enters the scene tree for the first time.
func _ready():
	for i in scriptParams.size():
		paramSelect.add_item(scriptParams[i].name)
	selectParam(selectedParam)


func selectParam(paramName):
	for i in paramSelect.items.size():
		if paramSelect.get_item_text(i) == paramName:
			paramSelect.select(i)
