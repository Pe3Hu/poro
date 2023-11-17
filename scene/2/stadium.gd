extends MarginContainer


@onready var hbox = $HBox
@onready var field = $HBox/VBox/Field
@onready var encounter = $HBox/VBox/Encounter


var tournament = null
var teams = []
var keeper = null
var guest = null


func set_attributes(input_: Dictionary) -> void:
	tournament = input_.tournament
	
	for team in input_.teams:
		add_team(team)
	
	var input = {}
	input.stadium = self
	field.set_attributes(input)
	
	switch_roles()
	switch_roles()
	markers_walkout()


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


func switch_roles() -> void:
	for team in teams:
		team.switch_role()


func markers_walkout() -> void:
	for team in teams:
		var arrangements = team.arrangements[field.side][team.role]
		
		for gladiator in team.mains:
			var grid = arrangements[gladiator.marker.order]
			var spot = field.grids.spot[grid]
			gladiator.marker.set_spot(spot)
