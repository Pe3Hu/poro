extends MarginContainer


@onready var dices = $Dices

var encounter = null
var side = null
var result = null
var rolls = []
var fixed = false


func set_attributes(input_: Dictionary) -> void:
	encounter  = input_.encounter
	side  = input_.side


func init_dices(dices_: int, faces_: int) -> void:
	for _i in dices_:
		add_dice(faces_)


func add_dice(faces_: int) -> void:
	var input = {}
	input.pool = self
	input.faces = faces_
	
	var dice = Global.scene.dice.instantiate()
	dices.add_child(dice)
	dice.set_attributes(input)


func roll_dices() -> void:
	rolls = []
	result = null
	
	for dice in dices.get_children():
		rolls.append(dice)
	
	for dice in dices.get_children():
		dice.roll()


func dice_stopped(dice_: MarginContainer) -> void:
	rolls.erase(dice_)
	
	if rolls.is_empty():
		update_result()


func update_result() -> void:
	result = 0
	
	for dice in dices.get_children():
		if result < dice.get_current_facet_value():
			result = dice.get_current_facet_value()
	
	var data = {}
	data.side = side
	data.value = result
	print(data)
	encounter.results.append(data)
	encounter.check_results()


func reset() -> void:
	fixed = false
	result = 0
	rolls = []
	
	while dices.get_child_count() > 0:
		var dice = dices.get_child(0)
		dices.remove_child(dice)
		dice.queue_free()


func set_fixed_value(value_: int) -> void:
	var dice = dices.get_child(0)
	dice.flip_to_value(value_)
