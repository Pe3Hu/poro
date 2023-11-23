extends MarginContainer


@onready var vigor = $HBox/Vigor
@onready var standard = $HBox/Standard
@onready var fatigue = $HBox/Fatigue

var gladiator = null
var value = {}
var limits = {}
var state = null
var effort = null
var overstrain = null


func set_attributes(input_: Dictionary) -> void:
	gladiator = input_.gladiator
	limits = input_.limits
	
	value.total = input_.value
	value.current = int(input_.value)
	init_states()


func init_states() -> void:
	for state in Global.arr.state:
		var indicator = get(state)
		
		var input = {}
		input.stamina = self
		input.state = state
		input.max = limits[state] * value.total
		indicator.set_attributes(input)
	
	update_state()


func update_state() -> void:
	for _state in Global.arr.state:
		var indicator = get(_state)
		
		if indicator.get_percentage() > 0:
			state = _state
			break

func make_an_effort(effort_: int) -> void:
	var indicator = get(state) 
	indicator.update_value("current", -effort_)
	update_state()


func exert_effort() -> void:
	var chances = Global.dict.temperament.title[gladiator.temperament].chances[state]
	effort = Global.get_random_key(chances)
	make_an_effort(Global.dict.effort[effort])
