extends MarginContainer


@onready var teams = $Teams

var game = null


func set_attributes(input_: Dictionary) -> void:
	game  = input_.game
	
	init_teams()


func init_teams() -> void:
	for _i in 2:
		var input = {}
		input.cradle = self
	
		var team = Global.scene.team.instantiate()
		teams.add_child(team)
		team.set_attributes(input)
