extends Line2D


var field = null
var spots = null
var side = null


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	spots = input_.spots
	side = input_.side
	
	for spot in spots:
		add_point(spot.center)
