extends MarginContainer


@onready var leftMarker = $Gladiators/Left/Marker
@onready var leftMax = $Gladiators/Left/Max
@onready var leftRoll = $Gladiators/Left/Roll
@onready var leftWinner = $Gladiators/Left/Winner
@onready var rightMarker = $Gladiators/Right/Marker
@onready var rightMax = $Gladiators/Right/Max
@onready var rightRoll = $Gladiators/Right/Roll
@onready var rightWinner = $Gladiators/Right/Winner

var stadium = null
var clash = null
var left = null
var right = null


func set_attributes(input_: Dictionary) -> void:
	stadium = input_.stadium


func set_clash(clash_: Node2D) -> void:
	clash = clash_
	
	for _i in clash.spots.keys().size():
		var role = clash.spots.keys()[_i]
		var spot = clash.spots[role]
		set(Global.arr.side[_i], spot.marker.gladiator)
	
	for side in Global.arr.side:
		var gladiator = get(side)
		var input = {}
		input.type = "marker"
		input.subtype = gladiator.team.status + " " + str(gladiator.marker.order)
		
		var icon = get(side+"Marker")
		icon.set_attributes(input)
		
		input.type = "prize"
		input.subtype = "2"
		icon = get(side+"Winner")
		icon.set_attributes(input)
	
	roll()


func roll() -> void:
	var datas = []
	
	for side in Global.arr.side:
		var gladiator = get(side)
		var aspect = gladiator.get("strength")
		var input = {}
		input.type = "number"
		input.subtype = aspect.get_performance_value(gladiator.state, gladiator.effort) 
		
		var icon = get(side+"Max")
		icon.set_attributes(input)
		
		Global.rng.randomize()
		input.subtype = Global.rng.randi_range(0, input.subtype)
		
		icon = get(side+"Roll")
		icon.set_attributes(input)
		
		var data = {}
		data.side = side
		data.value = input.subtype
		datas.append(data)
	
	if datas.front().value == datas.back().value:
		roll()
	else:
		datas.sort_custom(func(a, b): return a.value > b.value)
		
		var gladiator = get(datas.front().side)
		var input = {}
		input.type = "prize"
		input.subtype = "1"
		var icon = get(datas.front().side+"Winner")
		icon.set_attributes(input)


