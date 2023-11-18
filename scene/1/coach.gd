extends MarginContainer


var team = null
var tactic = null


func set_attributes(input_: Dictionary) -> void:
	team  = input_.team


func provide_guidance() -> void:
	tactic = Global.dict.tactic.role[team.role].keys().front()
	instruct_gladiators()


func instruct_gladiators() -> void:
	var description = Global.dict.tactic.role[team.role][tactic]
	
	for gladiator in team.mains:
		gladiator.guidance = {}
		
		for turn in description:
			gladiator.guidance[int(turn)] = []
			gladiator.guidance[int(turn)].append_array(description[turn][gladiator.marker.order])
