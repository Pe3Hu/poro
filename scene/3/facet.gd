extends MarginContainer


@onready var bg = $BG
@onready var icon = $HBox/Icon

var dice = null
var value = null


func set_attributes(input_: Dictionary) -> void:
	dice = input_.dice
	value = input_.value
	
	var input = {}
	input.type = "number"
	input.subtype = value
	icon.set_attributes(input)
	custom_minimum_size = Vector2(Global.vec.size.facet)

