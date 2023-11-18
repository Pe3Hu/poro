extends MarginContainer


@onready var gladiators = $HBox/Gladiators
@onready var coach = $HBox/Coach

var cradle = null
var stadium = null
var status = null
var role = null
var mains = []
var substitutes = []
var arrangements = {}


func set_attributes(input_: Dictionary) -> void:
	cradle  = input_.cradle
	
	var input = {}
	input.team = self
	coach.set_attributes(input)
	
	init_gladiators()
	init_arrangements()
	fill_main_gladiators()


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


func init_arrangements() -> void:
	for side in Global.arr.side:
		arrangements[side] = {}
		
		for role in Global.arr.role:
			arrangements[side][role] = {}
			
			for _i in Global.num.team.markers:
				for _j in Global.dict.spot.index:
					var description = Global.dict.spot.index[_j]
					#print(description)
					if description.side == side and description.role == role and description.order == _i + 1:
						arrangements[side][role][_i + 1] = description.grid
						break


func fill_main_gladiators() -> void:
	for gladiator in gladiators.get_children():
		mains.append(gladiator)


func switch_role() -> void:
	if role == null:
		match status:
			"keeper":
				role = "defense"
			"guest":
				role = "attack"
	else:
		role = Global.dict.mirror.role[role]

