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
	
		var stadium = Global.scene.stadium.instantiate()
		stadiums.add_child(stadium)
		stadium.set_attributes(input)

