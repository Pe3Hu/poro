extends Sprite2D


var field = null
var gladiator = null
var spot = null
var order = null
var carrier = false


func set_attributes(input_: Dictionary) -> void:
	set_gladiator(input_.gladiator)
	field = input_.field
	order = input_.order
	
	var path = "res://asset/png/icon/marker/" + gladiator.team.status + " " + str(order) + ".png"
	texture = load(path)
	scale = Global.vec.size.marker / Vector2(texture.get_width(), texture.get_height())


func set_gladiator(gladiator_: MarginContainer) -> void:
	if gladiator != null:
		gladiator.marker = null
	
	gladiator = gladiator_
	gladiator.marker = self


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
