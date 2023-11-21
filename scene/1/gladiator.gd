extends MarginContainer


@onready var strength = $Aspects/Strength
@onready var dexterity = $Aspects/Dexterity

var team = null
var marker = null
var rank = null
var predispositions = {}
var guidance = {}
var options = []
var clashes = null
var temperament = null
var endurance = null
var limits = null
var state = null
var effort = null
var action = null
var target = null
var clash = null
var destination = null
var architype = null
var role = null
var priority = null


func set_attributes(input_: Dictionary) -> void:
	team  = input_.team
	rank = input_.rank
	
	for type in Global.arr.aspect:
		var input = {}
		input.gladiator = self
		input.title = type
		input.predisposition = input_.predispositions[type]
		input.primary = input_.primary == type
		
		var aspect = get(type)
		aspect.set_attributes(input)
		
		if input.primary:
			aspect.set_performances()
	
	var secondary = get(Global.dict.aspect.reflection[input_.primary])
	secondary.set_performances()
	
	endurance = {}
	endurance.max = 100
	endurance.current = 100
	
	limits = {}
	limits.vigor = 0.75
	limits.standard = 0.25
	limits.fatigue = 0
	roll_temperament()
	update_state()


func roll_temperament() -> void:
	temperament = "administrator"


func update_state() -> void:
	for _state in Global.arr.state:
		if endurance.current > limits[_state] * endurance.max:
			state = _state
			break


func select_action() -> void:
	action = null
	priority = 0
	
	while action == null and priority < guidance.size():
		if check_trigger():
			set_action_based_on_act()
		else:
			priority += 1
	
	if action == null:
		action = "waiting"
	
	update_clash()


func verify_intent() -> void:
	if action == null:
		return
	
	if Global.dict.action.title[action].target != "several":
		return
	
	options = []
	
	match Global.dict.action.title[action].subtype:
		"movement":
			var paths = Global.get_paths_based_on_side_and_grid(team.stadium.field.side, marker.spot.grid)
			
			for path in paths:
				var grid = path.back()
				var spot = team.stadium.field.grids.spot[grid]
				
				if spot.marker == null and spot.declaration == null:
					options.append(path)
		"onslaught":
			for _clash in marker.spot.clashes[team.stadium.field.side]:
				var spot = marker.spot.clashes[team.stadium.field.side][_clash]
				
				if spot.marker != null:
					if spot.marker.gladiator.team != team:
						options.append(spot)
	
	if options.is_empty():
		action = null


func intent_declaration() -> void:
	if action == null:
		priority += 1
		return
	
	match Global.dict.action.title[action].subtype:
		"movement":
			var option = options.pick_random()
			var spots = []
			var spot = team.stadium.field.grids.spot[option[option.size()-2]]
			spots.append(spot)
			spot = team.stadium.field.grids.spot[option.back()]
			spots.append(spot)
			clash = team.stadium.field.get_clash_based_on_spots(spots)
			spot.declaration = self
			destination = spot
		"onslaught":
			var option = options.pick_random()
			var spots = []
			spots.append(marker.spot)
			spots.append(option)
			clash = team.stadium.field.get_clash_based_on_spots(spots)


func check_trigger() -> bool:
	if !guidance[priority].has("trigger"):
		return true
	
	var trigger = guidance[priority].trigger
	
	if !trigger.has("subject"):
		return true
	
	match trigger.subject:
		"carrier":
			if trigger.layer == "neighbor" and trigger.verge == "neighbor":
				var spot = marker.field.carrier.spot
				return spot.check_carrier_is_neighbor()
		"teamate":
			var teamates = get_teamates_based_on_trigger()
			return !teamates.is_empty()
		"self":
			return marker.spot.check_trigger(trigger)
	
	return true


func set_action_based_on_act() -> void:
	var act = guidance[priority].act
	
	if Global.arr.order.has(act):
		action = act
	else:
		match act:
			"movement":
				set_movement_action()
			"apotheosis":
				set_apotheosis_action()
			"long pass":
				set_options_based_on_victim_and_distance("furthest")
			"short pass":
				set_options_based_on_victim_and_distance("nearest")
	
	verify_intent()
	intent_declaration()


func update_clash() -> void:
	if clash == null:
		clash = marker.spot.clash
	
	clash.set_action(action)


func exert_effort() -> void:
	var chances = Global.dict.temperament.title[temperament].chances[state]
	effort = Global.get_random_key(chances)
	
	endurance.current -= Global.dict.effort[effort]
	update_state()


func roll_damage() -> String:
	return Global.get_random_key(Global.dict.damage.rnd)


func get_teamates_based_on_trigger() -> Array:
	var teamates = []
	var trigger = guidance[priority].trigger
	
	for teamate in team.mains:
		if teamate != self:
			if teamate.marker.spot.check_trigger(trigger):
				teamates.append(teamate)
	
	print(["get_teamates_based_on_trigger", teamates.size()])
	return teamates


func set_movement_action() -> void:
	if marker.spot.layers[marker.spot.field.side] == 6:
		action = "step"
	else:
		action = "slip"


func set_apotheosis_action() -> void:
	if marker.spot.layers[marker.spot.field.side] == 1:
		action = "trick"
	else:
		action = "throw"


func set_options_based_on_victim_and_distance(measure_: Variant) -> void:
	var datas = []
	var trigger = guidance[priority].trigger
	
	for teamate in team.mains:
		if teamate != self:
			if teamate.role == trigger.victim:
				var data = {}
				data.gladiator = teamate
				data.distance = get_distance_to_gladiators(teamate) 
				datas.append(data)
	
	if measure_ != null:
		match measure_:
			"nearest":
				datas.sort_custom(func(a, b): return a.distance < b.distance)
			"furthest":
				datas.sort_custom(func(a, b): return a.distance > b.distance)
	
	for data in datas:
		if data.distance == datas.front().distance:
			options.append(data.gladiator)


func get_distance_to_gladiators(gladiator_: MarginContainer) -> int:
	var side = marker.spot.field.side
	return abs(gladiator_.marker.spot.layers[side] - marker.spot.layers[side])
