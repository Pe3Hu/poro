extends MarginContainer


@onready var vigor = $VBox/Vigor
@onready var standard = $VBox/Standard
@onready var fatigue = $VBox/Fatigue
@onready var overheat = $VBox/Overheat
@onready var damage = $VBox/Damage

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
	
	var input = {}
	input.proprietor = self
	input.type = "damage"
	input.subtype = "lack"
	input.value = 0
	set_damage(input)


func init_states() -> void:
	for _state in Global.arr.state:
		var indicator = get(_state)
		
		var input = {}
		input.stamina = self
		input.state = _state
		input.max = limits[_state] * value.total
		indicator.set_attributes(input)
	
	update_state()
	make_an_effort(0)


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
	#make_an_effort(Global.dict.effort[effort])


func reset_overheat() -> void:
	overheat.stack.set_number(1)


func rise_overheat() -> void:
	overheat.stack.change_number(1)


func set_damage(input_: Dictionary) -> void:
	input_.proprietor = self
	damage.set_attributes(input_)
	damage.stack.visible = input_.value > 0
