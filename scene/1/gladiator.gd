extends MarginContainer


@onready var strength = $Aspects/Strength
@onready var dexterity = $Aspects/Dexterity

var team = null
var rank = null
var predispositions = {}


func set_attributes(input_: Dictionary) -> void:
	team  = input_.team
	rank = input_.rank
	
	for type in Global.arr.aspect:
		var input = {}
		input.gladiator = self
		input.title = type
		input.predisposition = input_.predispositions[type]
		input.primary = input_.primary == type
		
		var aspect = get(type)
		aspect.set_attributes(input)
		
		if input.primary:
			aspect.set_performances()
	
	var secondary = get(Global.dict.aspect.reflection[input_.primary])
	secondary.set_performances()
