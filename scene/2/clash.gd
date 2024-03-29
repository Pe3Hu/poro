extends Sprite2D


@onready var anchor = $Anchor

var field = null
var spots = null
var side = null
var action = null
var single = false
var values = {}


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	spots = input_.spots
	side = input_.side
	values.mince = 0
	values.shell = 0
	
	position = (spots.attack.center + spots.defense.center) / 2
	
	if spots.attack == spots.defense:
		position.y += Global.num.spot.h
		single = true
	
	set_action("empty")
	
	for role in spots:
		var spot = spots[role]
		spot.add_clash(self)


func set_action(action_: String) -> void:
	action = action_
	var path = "res://asset/png/icon/action/" + action + ".png"
	texture = load(path)
	scale = Global.vec.size.action / Vector2(texture.get_width(), texture.get_height())
	visible = true
	
	if action != "empty" and action != "waiting":
		var description = Global.dict.action.title[action_]
		
		if description.type == "initiation" and !field.stadium.clashes[action].has(self):
			field.stadium.clashes[action].append(self)


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


func reset() -> void:
	action = null
	set_action("empty")
	visible = false
	#field.stadium.end_of_clash(self)
