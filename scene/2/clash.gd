extends Node2D


@onready var anchor = $Anchor


var field = null
var spots = null
var side = null


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	spots = input_.spots
	side = input_.side
	
	position = (spots.attack.center + spots.defense.center) / 2
	init_vertexs()
	anchor.color = Global.color.anchor
	
	for role in spots:
		var spot = spots[role]
		spot.add_clash(self)


func init_vertexs() -> void:
	var n = 4
	var vertexs = []
	var angle = PI * 2 / n
	
	for _i in n:
		var vertex = Vector2.from_angle(angle * _i) * Global.num.anchor.r
		vertexs.append(vertex)
	
	anchor.set_polygon(vertexs)


func get_opponent_spot(spot_: Polygon2D) -> Variant:
	for type in spots:
		var spot = spots[type]
		
		if spot_ != spot:
			return spot
	
	return null
