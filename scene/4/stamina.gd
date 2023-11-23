extends MarginContainer


@onready var vigor = $HBox/Vigor
@onready var standard = $HBox/Fatigue
@onready var fatigue = $HBox/Fatigue

var gladiator = null


func set_attributes(input_: Dictionary) -> void:
	gladiator = input_.gladiator

