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
				for grid in Global.dict.spot.grid:
					if Global.dict.spot.grid[grid].has(side):
						var description = Global.dict.spot.grid[grid][side]
						
						if description.role == role and description.order == _i + 1:
							arrangements[side][role][_i + 1] = grid
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
		gladiator.architype = description[gladiator.marker.order]
		gladiator.guidance = []
		gladiator.guidance.append_array(Global.dict.architype.title[gladiator.architype])
