extends MarginContainer


@onready var icon = $Icon

var stadium = null
var gladiator = null
var grid = null


func set_attributes(input_: Dictionary) -> void:
	#gladiator = input_.gladiator
	stadium = input_.stadium
	
	
	var input = {}
	input.type = "marker"
	input.subtype = "blue" + " " + "1"
	icon.set_attributes(input)
	icon.custom_minimum_size = Vector2(Global.vec.size.marker)
	#position = Vector2.ONE * -12
	set_grid(input_.grid)


func set_grid(grid_: Vector2) -> void:
	grid = grid_
	
	#position = stadium.left.map_to_local(grid)
	#position = stadium.left.local_to_map(grid) * stadium.scale
	
	#position = grid * stadium.cell# + stadium.offset
	#position = (grid + Vector2.ONE * 0.5) * stadium.cell + stadium.offset
	#position.x = grid.x * stadium.cell.x
	#position.y = grid.y * stadium.cell.y
	#position += stadium.offset
	#position -= Vector2(Global.vec.size.marker) * 0.5
	position = Vector2()
	pass
