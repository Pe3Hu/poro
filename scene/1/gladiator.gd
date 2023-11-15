extends MarginContainer


@onready var strength = $Aspects/Strength
@onready var dexterity = $Aspects/Dexterity


var team = null
var rank = null


func set_attributes(input_: Dictionary) -> void:
	team  = input_.team
	rank = 0
	
	for type in Global.arr.aspect:
		var input = {}
		input.gladiator = self
		input.aspect = type
		var aspect = get(type)
		aspect.set_attributes(input)
