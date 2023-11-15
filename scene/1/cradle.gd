extends MarginContainer


@onready var teams = $Teams

var sketch = null


func set_attributes(input_: Dictionary) -> void:
	sketch  = input_.sketch
	
	init_teams()


func init_teams() -> void:
	for _i in 1:
		var input = {}
		input.cradle = self
	
		var team = Global.scene.team.instantiate()
		teams.add_child(team)
		team.set_attributes(input)
