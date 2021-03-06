extends HBoxContainer

onready var graphEdit = get_tree().get_root().find_node("GraphEdit", true, false)

var scopeSelect
var typeSelect
var paramNameField
var paramValueField

var _paramName
var _paramScope
var _paramType
var _paramValue

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func loadParam(scriptParam):
	scopeSelect = self.find_node("ScopeSelect")
	typeSelect = self.find_node("TypeSelect")
	paramNameField = self.find_node("ParamNameField")
	paramValueField = self.find_node("ParamValueField")
	setVisibility(scriptParam.scope)
	setParamValue(scriptParam.type, scriptParam.value)
	setParamName(scriptParam.name)

func setVisibility(visibility):
	if scopeSelect == null:
		scopeSelect = self.find_node("ScopeSelect")
	if visibility == "private":
		scopeSelect.selectedScope = 0
	elif visibility == "protected":
		scopeSelect.selectedScope = 1
	elif visibility == "public":
		scopeSelect.selectedScope = 2
	_paramScope = visibility

func setParamName(paramName):
	if paramNameField == null:
		paramNameField = self.find_node("ParamNameField")
	paramNameField.text = paramName
	self._paramName = paramName

func setParamValue(paramType, paramValue):
	if typeSelect == null:
		typeSelect = self.find_node("TypeSelect")
	if paramValueField == null:
		paramValueField = self.find_node("ParamValueField")
	if paramType == "bool":
		typeSelect.selectedType = 0
		paramValueField.queue_free()
		paramValueField = CheckBox.new()
		paramValueField.pressed = paramValue
		paramValueField.size_flags_horizontal = 1
		add_child(paramValueField)
	elif paramType == "int":
		typeSelect.selectedType = 1
		paramValueField.queue_free()
		paramValueField = LineEdit.new()
		paramValueField.text = str(paramValue)
		paramValueField.size_flags_horizontal = 3
		add_child(paramValueField)
	elif paramType == "string":
		typeSelect.selectedType = 2
		paramValueField.queue_free()
		paramValueField = LineEdit.new()
		paramValueField.text = paramValue
		paramValueField.size_flags_horizontal = 3
		add_child(paramValueField)
	self._paramType = paramType
	self._paramValue = paramValue


func _on_DeleteParamButton_pressed():
	graphEdit.removeParam({
		"name": _paramName,
		"scope": _paramScope,
		"type": _paramType,
		"value": _paramValue
	})
	self.queue_free()
