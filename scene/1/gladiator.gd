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
	
	while action == null and !guidance[team.stadium.counter.turn].is_empty():
		action = guidance[team.stadium.counter.turn].pop_front()
		verify_intent()
		intent_declaration()
	
	if action == null:
		action = "waiting"
	
	update_clash()


func verify_intent() -> void:
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
			for clash in marker.spot.clashes[team.stadium.field.side]:
				var spot = marker.spot.clashes[team.stadium.field.side][clash]
				
				if spot.marker != null:
					if spot.marker.gladiator.team != team:
						options.append(spot)
	
	if options.is_empty():
		action = null


func intent_declaration() -> void:
	if action == null:
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
