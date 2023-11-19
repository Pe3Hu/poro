extends MarginContainer


var team = null
var tactic = null
var arrangements = {}


func set_attributes(input_: Dictionary) -> void:
	team  = input_.team
	
	init_arrangements()
	fill_main_gladiators()


func init_arrangements() -> void:
	for side in Global.arr.side:
		arrangements[side] = {}
		
		for role in Global.arr.role:
			arrangements[side][role] = {}
			
			for _i in Global.num.team.markers:
				for _j in Global.dict.spot.index:
					var description = Global.dict.spot.index[_j]
					
					if description.side == side and description.role == role and description.order == _i + 1:
						arrangements[side][role][_i + 1] = description.grid
						break


func fill_main_gladiators() -> void:
	for gladiator in team.gladiators.get_children():
		team.mains.append(gladiator)


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
