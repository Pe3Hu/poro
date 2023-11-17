extends MarginContainer


@onready var icons = $Icons

var gladiator = null
var title = null
var predisposition = null
var primary = null


func set_attributes(input_: Dictionary) -> void:
	gladiator = input_.gladiator
	title = input_.title
	predisposition = input_.predisposition
	primary = input_.primary
	
	init_icons()


func init_icons() -> void:
	var first = ["icon", "icon", "icon", "icon"]
	var second = ["icon", "performance", "performance", "performance"]
	
	for _i in 4:
		var types = second
		
		if _i == 0:
			types = first
		
		for _j in types.size():
			var type  = types[_j]
			var input = {}
		
			var icon = Global.scene[type].instantiate()
			icons.add_child(icon)
			
			if type == "icon":
				if _i == 0:
					if _j == 0:
						input.type = "aspect"
						input.subtype = title
					else:
						input.type = "state"
						input.subtype = Global.arr.state[_j-1]
				else:
					input.type = "effort"
					input.subtype = Global.arr.effort[_i-1]
				
				icon.set_attributes(input)


func set_performances() -> void:
	var description = Global.dict.aspect.rank[gladiator.rank].predispositions
	
	for _i in 3:
		for _j in 3:
			var grid = Vector2.ONE + Vector2(_j, _i)
			var performance = get_icon(grid)
			
			var input = {}
			input.aspect = self
			input.state = Global.arr.state[_j]
			input.effort = Global.arr.effort[_i]
			
			if primary:
				input.value = description[predisposition].states[input.state][input.effort]
			else:
				var reflection = gladiator.get(Global.dict.aspect.reflection[title])
				var primary_ = reflection.get_performance_value(input.state, input.effort)
				input.value = description[10].states[input.state][input.effort] - primary_
			
			performance.set_attributes(input)


func get_icon(grid_: Vector2) -> Variant:
	var index = icons.columns * grid_.y + grid_.x
	var icon = icons.get_child(index)
	return icon


func get_performance(state_: String, effort_: String) -> MarginContainer:
	var x = Global.arr.state.find(state_) + 1
	var y = Global.arr.effort.find(effort_) + 1
	var index = icons.columns * y + x
	var icon = icons.get_child(index)
	return icon


func get_performance_value(state_: String, effort_: String) -> int:
	var performance = get_performance(state_, effort_)
	return performance.icon.get_number()
