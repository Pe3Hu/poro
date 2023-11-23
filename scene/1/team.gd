extends MarginContainer


@onready var gladiators = $HBox/Gladiators
@onready var coach = $HBox/Coach

var cradle = null
var stadium = null
var status = null
var role = null
var mains = []
var markers = []
var substitutes = []


func set_attributes(input_: Dictionary) -> void:
	cradle  = input_.cradle
	
	init_gladiators()
	
	var input = {}
	input.team = self
	coach.set_attributes(input)


func init_gladiators() -> void:
	for _i in Global.num.team.markers:
		var input = {}
		input.team = self
		input.rank = 0
		input.primary = "strength"
		input.predispositions = {}
		input.predispositions["strength"] = 5
		input.predispositions["dexterity"] = 10 - input.predispositions["strength"]
	
		var gladiator = Global.scene.gladiator.instantiate()
		gladiators.add_child(gladiator)
		gladiator.set_attributes(input)


func switch_role() -> void:
	if role == null:
		match status:
			"keeper":
				role = "defense"
			"guest":
				role = "attack"
	else:
		role = Global.dict.mirror.role[role]

