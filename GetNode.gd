extends GraphNode

onready var paramSelect = $ParamSelect
var selectParams
var selectedParam


# Called when the node enters the scene tree for the first time.
func _ready():
	refreshParamList(selectParams)

func refreshParamList(scriptParams):
	selectParams = scriptParams
	paramSelect.clear()
	for i in scriptParams.size():
		paramSelect.add_item(scriptParams[i].name)
	selectParam(selectedParam)


func selectParam(paramName):
	var param
	for i in selectParams.size():
		if selectParams[i].name == paramName:
			param = selectParams[i]
	for i in paramSelect.items.size():
		if paramSelect.get_item_text(i) == paramName:
			paramSelect.select(i)
			var slot1color = get_slot_color_left(1)
			if param.type == "bool":
				set_slot(1, false, 0, slot1color, true, 1, Color.red)
			elif param.type == "int":
				set_slot(1, false, 0, slot1color, true, 2, Color.green)
			elif param.type == "string":
				set_slot(1, false, 0, slot1color, true, 3, Color.pink)


func _on_ParamSelect_item_selected(id):
	selectParam(paramSelect.text)
