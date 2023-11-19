extends MarginContainer


@onready var leftMarker = $Gladiators/Left/HBox/Marker
@onready var leftMax = $Gladiators/Left/HBox/Max
@onready var leftPool = $Gladiators/Left/Pool
@onready var leftWinner = $Gladiators/Left/Winner
@onready var rightMarker = $Gladiators/Right/HBox/Marker
@onready var rightMax = $Gladiators/Right/HBox/Max
@onready var rightPool = $Gladiators/Right/Pool
@onready var rightWinner = $Gladiators/Right/Winner
@onready var titleIcon = $Gladiators/Icon

var stadium = null
var clash = null
var left = null
var right = null
var winner = null
var loser = null
var results = []


func set_attributes(input_: Dictionary) -> void:
	stadium = input_.stadium


func set_clash(clash_: Node2D) -> void:
	visible = true
	clash = clash_
	
	if clash.action != "waiting" and clash.action != "empty":
		for _i in clash.spots.keys().size():
			var role = clash.spots.keys()[_i]
			var spot = clash.spots[role]
			var gladiator = spot.declaration
			
			if spot.marker != null:
				gladiator = spot.marker.gladiator
			
			set(Global.arr.side[_i], gladiator)
		
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
			
			input.encounter = self
			input.side = side
			var pool = get(side+"Pool")
			pool.set_attributes(input)
		
		var input = {}
		input.type = "action"
		input.subtype = clash.action
		titleIcon.set_attributes(input)
	
		roll_pool()
		reroll_pool()
	else:
		apply_result()


func roll_pool() -> void:
	results = []
	
	for side in Global.arr.side:
		var gladiator = get(side)
		var aspect = gladiator.get("strength")
		var input = {}
		input.type = "number"
		input.subtype = aspect.get_performance_value(gladiator.state, gladiator.effort) 
		
		var icon = get(side+"Max")
		icon.set_attributes(input)
		
		var pool = get(side+"Pool")
		pool.init_dices(1, input.subtype)
		pool.roll_dices()


func check_results() -> void:
	if results.size() == 2:
		if results.front().value == results.back().value:
			reroll_pool()
		else:
			results.sort_custom(func(a, b): return a.value > b.value)
			winner = get(results.front().side)
			loser = get(results.back().side)
			
			var input = {}
			input.type = "prize"
			input.subtype = "1"
			
			var icon = get(results.front().side+"Winner")
			icon.set_attributes(input)
			icon.visible = true
			
			icon = get(results.back().side+"Winner")
			icon.visible = false
			apply_result()


func reroll_pool() -> void:
	results = []
	
	for side in Global.arr.side:
		var pool = get(side+"Pool")
		pool.roll_dices()


func apply_result() -> void:
	if clash.action != "waiting" and clash.action != "empty":
		var description = Global.dict.action.title[clash.action]
		
		match description.subtype:
			"movement":
				if winner.destination != null:
					winner.marker.set_spot(winner.destination)
					winner.destination = null
				else:
					loser.get_damage()
			"onslaught":
					loser.get_damage()
		
		leftPool.reset()
		rightPool.reset()
	
	clash.reset()
