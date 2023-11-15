extends MarginContainer


@onready var gladiators = $Gladiators

var cradle = null


func set_attributes(input_: Dictionary) -> void:
	cradle  = input_.cradle
	
	init_gladiators()


func init_gladiators() -> void:
	for _i in 1:
		var input = {}
		input.team = self
	
		var gladiator = Global.scene.gladiator.instantiate()
		gladiators.add_child(gladiator)
		gladiator.set_attributes(input)