extends MarginContainer


@onready var hbox = $HBox
@onready var field = $HBox/VBox/Field
@onready var encounter = $HBox/VBox/Encounter


var tournament = null
var teams = []
var keeper = null
var guest = null
var counter = {}
var clashes = {}
var phase = null


func set_attributes(input_: Dictionary) -> void:
	tournament = input_.tournament
	
	for team in input_.teams:
		add_team(team)
	
	var input = {}
	input.stadium = self
	field.set_attributes(input)
	encounter.set_attributes(input)
	
	for action in Global.arr.order:
		clashes[action] = []
	
	counter.round = 0
	next_round()
	
	for _i in 7:
		next_clash()


func add_team(team_: MarginContainer) -> void:
	team_.cradle.teams.remove_child(team_)
	hbox.add_child(team_)
	
	if teams.is_empty():
		keeper = team_
		team_.status = "keeper"
		hbox.move_child(team_, 0)
	else:
		guest = team_
		team_.status = "guest"
	
	teams.append(team_)
	team_.stadium = self


func next_round() -> void:
	counter.round += 1
	counter.turn = 0
	
	for team in teams:
		team.switch_role()
		team.coach.provide_guidance()
	
	markers_walkout()
	next_turn()


func next_turn() -> void:
	counter.turn += 1
	phase = null
	
	next_phase()
	load_balance()
	next_clash()


func markers_walkout() -> void:
	for team in teams:
		var arrangements = team.coach.arrangements[field.side][team.role]
		
		for gladiator in team.mains:
			var grid = arrangements[gladiator.marker.order]
			var spot = field.grids.spot[grid]
			gladiator.marker.set_spot(spot)


func load_balance() -> void:
	for team in teams:
		for gladiator in team.mains:
			gladiator.select_action()
			gladiator.exert_effort()


func next_phase() -> void:
	if phase == Global.arr.order.back():
		phase = null
		return
	
	if phase == null:
		phase = Global.arr.order.front()
	else:
		var index = Global.arr.order.find(phase) + 1
		phase = Global.arr.order[index]


func next_clash() -> void:
	if phase != null:
		if clashes[phase].is_empty():
			next_phase()
			next_clash()
		else:
			var clash = clashes[phase].pop_front()
			encounter.set_clash(clash)
	else:
		end_of_turn()


func end_of_turn() -> void:
	if counter.turn == Global.num.round.turns:
		next_turn()
	else:
		next_round()
