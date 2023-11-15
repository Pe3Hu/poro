extends MarginContainer


@onready var icons = $Icons

var gladiator = null
var aspect = null
var predisposition = 5


func set_attributes(input_: Dictionary) -> void:
	gladiator  = input_.gladiator
	aspect = input_.aspect
	
	init_icons()
	set_performances()


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
						input.subtype = aspect
					else:
						input.type = "state"
						input.subtype = Global.arr.state[_j-1]
				else:
					input.type = "effort"
					input.subtype = Global.arr.effort[_i-1]
				
				icon.set_attributes(input)


func set_performances() -> void:
	var a = Global.dict.aspect.rank
	var description = Global.dict.aspect.rank[gladiator.rank].predispositions[predisposition]
	
	for _i in 3:
		for _j in 3:
			var grid = Vector2.ONE + Vector2(_j, _i)
			var performance = get_icon(grid)
			
			var input = {}
			input.aspect = self
			input.state = Global.arr.state[_j]
			input.effort = Global.arr.effort[_i]
			input.value = description.states[input.state][input.effort]
			performance.set_attributes(input)


func get_icon(grid_: Vector2) -> Variant:
	var index = icons.columns * grid_.y + grid_.x
	var icon = icons.get_child(index)
	return icon
