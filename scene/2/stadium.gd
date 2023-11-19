extends MarginContainer


@onready var hbox = $HBox
@onready var field = $HBox/VBox/Field
@onready var encounter = $HBox/VBox/Encounter


var tournament = null
var teams = []
var keeper = null
var guest = null
var counter = {}


func set_attributes(input_: Dictionary) -> void:
	tournament = input_.tournament
	
	for team in input_.teams:
		add_team(team)
	
	var input = {}
	input.stadium = self
	field.set_attributes(input)
	encounter.set_attributes(input)
	
	counter.round = 0
	next_round()


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
	
	load_balance()
	field.roll_clashes()


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

