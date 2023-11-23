extends Sprite2D


var field = null
var team = null
var gladiator = null
var spot = null
var order = null
var carrier = false


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	team = input_.team
	order = input_.order
	team.markers.append(self)
	
	var path = "res://asset/png/icon/marker/" + team.status + " " + str(order) + ".png"
	texture = load(path)
	scale = Global.vec.size.marker / Vector2(texture.get_width(), texture.get_height())


func set_gladiator(gladiator_: MarginContainer) -> void:
	if gladiator != null:
		gladiator.set_marker(null)
	
	gladiator = gladiator_
	gladiator.set_marker(self)


func set_spot(spot_: Sprite2D) -> void:
	if spot != null:
		spot.marker = null
	
	spot = spot_
	spot.marker = self
	position = spot.center


func set_carrier() -> void:
	carrier = true
	field.carrier = self
	spot.update_based_on_side()


func reset_carrier() -> void:
	carrier = false
	field.carrier = null
	spot.update_based_on_side()


func check_teamate(marker_: Sprite2D) -> bool:
	return marker_.gladiator.team == gladiator.team
