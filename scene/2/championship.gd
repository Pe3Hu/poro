extends MarginContainer


@onready var tournaments = $Tournaments

var game = null


func set_attributes(input_: Dictionary) -> void:
	game  = input_.game
	
	init_tournaments()


func init_tournaments() -> void:
	for _i in 1:
		var input = {}
		input.championship = self
	
		var tournament = Global.scene.tournament.instantiate()
		tournaments.add_child(tournament)
		tournament.set_attributes(input)

