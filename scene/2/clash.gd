extends Sprite2D


@onready var anchor = $Anchor


var field = null
var spots = null
var side = null
var action = null
var single = false


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	spots = input_.spots
	side = input_.side
	
	position = (spots.attack.center + spots.defense.center) / 2
	
	if spots.attack == spots.defense:
		position.y += Global.num.spot.h
		single = true
	
	set_action("empty")
	
	for role in spots:
		var spot = spots[role]
		spot.add_clash(self)


func set_action(action_: String) -> void:
	var path = "res://asset/png/icon/action/" + action_ + ".png"
	texture = load(path)
	scale = Global.vec.size.action / Vector2(texture.get_width(), texture.get_height())
	visible = true


func init_vertexs() -> void:
	var n = 4
	var vertexs = []
	var angle = PI * 2 / n
	
	for _i in n:
		var vertex = Vector2.from_angle(angle * _i) * Global.num.anchor.r
		vertexs.append(vertex)
	
	anchor.set_polygon(vertexs)


func get_opponent_spot(spot_: Sprite2D) -> Variant:
	if single:
		return spot_
	
	for type in spots:
		var spot = spots[type]
		
		if spot_ != spot:
			return spot
	
	return null

