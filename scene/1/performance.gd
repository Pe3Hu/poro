extends MarginContainer


@onready var icon = $Icon

var aspect = null
var state = null
var effort = null


func set_attributes(input_: Dictionary) -> void:
	aspect = input_.aspect
	state = input_.state
	effort = input_.effort
	
	var input = {}
	input.type = "number"
	input.subtype = input_.value
	icon.set_attributes(input)


func get_value() -> int:
	return icon.get_number()
