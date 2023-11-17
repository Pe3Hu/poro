extends Sprite2D


var field = null
var gladiator = null
var spot = null
var order = null


func set_attributes(input_: Dictionary) -> void:
	set_gladiator(input_.gladiator)
	field = input_.field
	order = input_.order
	
	var path = "res://asset/png/icon/marker/" + gladiator.team.status + " " + str(order) + ".png"
	#var image = Image.load_from_file(path)
	#texture = ImageTexture.create_from_image(image)
	#texture.set_size_override(Global.vec.size.marker)
	texture = load(path)
	scale = Global.vec.size.marker / Vector2(texture.get_width(), texture.get_height())


func set_gladiator(gladiator_: MarginContainer) -> void:
	if gladiator != null:
		gladiator.marker = null
	
	gladiator = gladiator_
	gladiator.marker = self


func set_spot(spot_: Polygon2D) -> void:
	spot = spot_
	position = spot.center
