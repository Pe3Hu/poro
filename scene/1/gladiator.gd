extends MarginContainer


@onready var strength = $Aspects/Strength
@onready var dexterity = $Aspects/Dexterity

var team = null
var marker = null
var rank = null
var predispositions = {}
var temperament = null
var endurance = null
var limits = null
var state = null
var effort = null


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
	
	endurance = {}
	endurance.max = 100
	endurance.current = 100
	
	limits = {}
	limits.vigor = 0.75
	limits.standard = 0.25
	limits.fatigue = 0
	roll_temperament()
	update_state()


func roll_temperament() -> void:
	temperament = "administrator"


func update_state() -> void:
	for _state in Global.arr.state:
		if endurance.current > limits[_state] * endurance.max:
			state = _state
			break


func exert_effort() -> void:
	var chances = Global.dict.temperament.title[temperament].chances[state]
	effort = Global.get_random_key(chances)
	
	endurance.current -= Global.dict.effort[effort]
	update_state()
