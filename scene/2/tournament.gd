extends MarginContainer


@onready var stadiums = $Stadiums

var championship = null


func set_attributes(input_: Dictionary) -> void:
	championship  = input_.championship
	
	init_stadiums()


func init_stadiums() -> void:
	for _i in 1:
		var input = {}
		input.tournament = self
		input.teams = []
		input.teams.append(Global.node.game.cradle.teams.get_child(0))
		input.teams.append(Global.node.game.cradle.teams.get_child(1))
	
		var stadium = Global.scene.stadium.instantiate()
		stadiums.add_child(stadium)
		stadium.set_attributes(input)
