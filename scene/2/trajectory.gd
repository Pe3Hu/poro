extends Line2D


var field = null
var sender = null
var transferee = null
var interceptors = {}


func set_attributes(input_: Dictionary) -> void:
	field = input_.field


func set_markers(sender_: Sprite2D, transferee_: Sprite2D) -> void:
	sender = sender_
	transferee = transferee_
	
	set_interceptors()


func set_interceptors() -> void:
	var spots = [sender.spot, transferee.spot]
	var routes = field.get_all_routes_based_on_spots(spots)
	interceptors = {}
	
	for route in routes:
		for spot in route:
			if spot.marker != null:
				var interceptor = spot.marker
				
				if !sender.check_teamate(interceptor):
					if !interceptors.has(interceptor):
						interceptors[interceptor] = 0
					
					interceptors[interceptor] += 1
	
	if sender.spot.layers[field.side] == transferee.spot.layers[field.side]:
		for _i in range(interceptors.keys().size()-1, -1, -1):
			var interceptor = interceptors.keys()[_i]
			
			if abs(interceptor.spot.layers[field.side] - sender.spot.layers[field.side]) != 1:
				interceptors.erase(interceptor)
	
	allow_interceptors_catch()


func allow_interceptors_catch() -> void:
	if !interceptors.keys().is_empty():
		allow_transferee_catch()
		return
	
	if true:
		allow_transferee_catch()


func allow_transferee_catch() -> void:
#	var a = sender.spot.clash
#	var input = {}
#	input.actions = {}
#	input.actions.parent = "pass"
#	input.actions.child = "catch"
#	input.markers = {}
#	input.markers.parent = sender
#	input.markers.child = transferee
	field.stadium.encounter.reactions.append(transferee.spot.clash)
	#field.stadium.encounter.set_reaction(input)
