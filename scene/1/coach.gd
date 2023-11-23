extends MarginContainer


var team = null
var tactic = null
var arrangements = {}


func set_attributes(input_: Dictionary) -> void:
	team  = input_.team
	
	init_arrangements()


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
	team.mains = []
	
	for gladiator in team.gladiators.get_children():
		team.mains.append(gladiator)
	
	for _i in team.mains.size():
		var marker = team.markers[_i]
		var gladiator = team.mains[_i]
		marker.set_gladiator(gladiator)


func provide_guidance() -> void:
	tactic = Global.dict.tactic.role[team.role].keys().front()
	instruct_gladiators()


func instruct_gladiators() -> void:
	var description = Global.dict.tactic.role[team.role][tactic]
	
	for gladiator in team.mains:
		gladiator.architype = description[gladiator.marker.order]
		gladiator.role = Global.dict.architype.title[gladiator.architype].role
		gladiator.guidance = []
		gladiator.guidance.append_array(Global.dict.architype.title[gladiator.architype].guidance)
