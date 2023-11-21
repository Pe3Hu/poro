extends Line2D


var field = null
var sender = null
var transferee = null
var interceptors = []


func set_attributes(input_: Dictionary) -> void:
	field = input_.field


func set_markers(sender_: Sprite2D, transferee_: Sprite2D) -> void:
	sender = sender_
	transferee = transferee_
	interceptors = []
	
	set_interceptors()


func set_interceptors() -> void:
	var spots = [sender.spot, transferee.spot]
	var routes = field.get_all_routes_based_on_spots(spots)
