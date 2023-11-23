extends Line2D


var field = null
var sender = null
var transferee = null
var subtype = null
var interceptors = {}


func set_attributes(input_: Dictionary) -> void:
	field = input_.field


func set_spots(subtype_: String, sender_: Sprite2D, transferee_: Sprite2D) -> void:
	sender = sender_
	transferee = transferee_
	subtype = subtype_

	set_interceptors()


func set_interceptors() -> void:
	var spots = [sender, transferee]
	var routes = field.get_all_routes_based_on_spots(spots)
	interceptors = {}
	
	for route in routes:
		for spot in route:
			if spot.marker != null:
				var interceptor = spot.marker
				
				if !sender.marker.check_teamate(interceptor):
					if !interceptors.has(interceptor):
						interceptors[interceptor] = 0
					
					interceptors[interceptor] += 1
	
	if sender.layers[field.side] == transferee.layers[field.side]:
		for _i in range(interceptors.keys().size()-1, -1, -1):
			var interceptor = interceptors.keys()[_i]
			
			if abs(interceptor.spot.layers[field.side] - sender.layers[field.side]) != 1:
				interceptors.erase(interceptor)
	
	allow_interceptors_to_reaction()
	
	if subtype == "pass":
		allow_transferee_to_reaction()


func allow_interceptors_to_reaction() -> void:
	if !interceptors.keys().is_empty():
		for interceptor in interceptors:
			field.stadium.encounter.reactions.append(interceptor.clash)


func allow_transferee_to_reaction() -> void:
	field.stadium.encounter.reactions.append(transferee.clash)
