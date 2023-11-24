extends MarginContainer


@onready var leftMarker = $Gladiators/Left/HBox/Marker
@onready var leftMax = $Gladiators/Left/HBox/Max
@onready var leftPool = $Gladiators/Left/Pool
@onready var leftWinner = $Gladiators/Left/Winner
@onready var rightMarker = $Gladiators/Right/HBox/Marker
@onready var rightMax = $Gladiators/Right/HBox/Max
@onready var rightPool = $Gladiators/Right/Pool
@onready var rightWinner = $Gladiators/Right/Winner
@onready var initiationIcon = $Gladiators/Icons/Initiation
@onready var reactionIcon = $Gladiators/Icons/Reaction

var stadium = null
var initiation = null
var reaction = null
var left = null
var right = null
var winner = null
var loser = null
var results = []
var fixed = []
var reactions = []
var hides = []
var kind = null


func set_attributes(input_: Dictionary) -> void:
	stadium = input_.stadium
	
	custom_minimum_size = Global.vec.size.encounter
	hides = ["pass", "slip", "breakthrough"]


func set_initiation(initiation_: Node2D) -> void:
	kind = "initiation"
	visible = true
	initiation = initiation_
	
	if initiation.action != "waiting" and initiation.action != "empty":
		for _i in initiation.spots.keys().size():
			var role = initiation.spots.keys()[_i]
			var spot = initiation.spots[role]
			var gladiator = spot.declaration
			
			if spot.marker != null:
				gladiator = spot.marker.gladiator
			
			set(Global.arr.side[_i], gladiator)
		
		if left == right:
			fixed.append("right")
		
		for side in Global.arr.side:
			update_side_icons(side)
		
		var input = {}
		input.type = "action"
		input.subtype = initiation.action
		initiationIcon.set_attributes(input)
	
		roll_pool()
		reroll_pool()
		
		if hides.has(input.subtype):
			leftWinner.visible = false
			rightMarker.visible = false
			rightPool.visible = false
			rightWinner.visible = false


func update_side_icons(side_: String) -> void:
	var gladiator = get(side_)
	var input = {}
	input.type = "marker"
	input.subtype = gladiator.team.status + " " + str(gladiator.marker.order)
	
	var icon = get(side_+"Marker")
	icon.set_attributes(input)
	icon.visible = true
	
	input.type = "prize"
	input.subtype = "2"
	icon = get(side_+"Winner")
	icon.set_attributes(input)
	icon.visible = true
	
	input.encounter = self
	input.side = side_
	var pool = get(side_+"Pool")
	pool.set_attributes(input)
	pool.visible = true


func roll_pool() -> void:
	for side in Global.arr.side:
		var pool = get(side+"Pool")
		
		if !fixed.has(side):
			var gladiator = get(side)
			var aspect = gladiator.get("strength")
			var input = {}
			input.type = "number"
			input.subtype = aspect.get_performance_value(gladiator.stamina.state, gladiator.stamina.effort) 
			
			var icon = get(side+"Max")
			icon.set_attributes(input)
		
			pool.init_dices(1, input.subtype)
			pool.roll_dices()


func reroll_pool() -> void:
	if left == right:
		return
	
	if kind == "reaction":
		return
	
	results = []
	
	for side in Global.arr.side:
		if !fixed.has(side):
			var pool = get(side+"Pool")
			pool.roll_dices()
	
	#check_results()


func check_results() -> void:
	var a = results.size()
	match results.size():
		1:
			if fixed.size() == 1:
				for side in Global.arr.side:
					if !fixed.has(side):
						winner = get(side)
			
				apply_result()
		2:
			results.sort_custom(func(a, b): return a.value > b.value)
			
			if results.front().value == results.back().value:
				match kind:
					"initiation":
						reroll_pool()
						return
					"reaction":
						if initiation.action == "pass" and left.marker.check_teamate(right.marker):
							if results.front().side == "left":
								var result = results.pop_front()
								results.append(result)
								pass
			
			if right == left and results.front().side == "right":
				var result = results.pop_front()
				results.append(result)
		
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


func apply_result() -> void:
	if reaction == null:
		if initiation.action != "waiting" and initiation.action != "empty":
			var description = Global.dict.action.title[initiation.action]
			var data = {}
			data.subtype = description.subtype
			
			match description.subtype:
				"movement":
					if initiation.action != "step":
						stadium.field.trajectory.set_spots(initiation.action, left.marker.spot, left.destination)
				"onslaught":
					data.gladiator = loser
					data.damage = loser.roll_damage()
				"transfer":
					match right.action:
						"pass":
							left.marker.spot.clash.values.mince = results.front().value
							stadium.field.trajectory.set_spots(initiation.action, left.marker.spot, left.transferee.marker.spot)
	else:
		var description = Global.dict.action.title[initiation.action]
		
		match description.subtype:
			"movement":
				if winner == left:
					winner.marker.set_spot(winner.destination)
				else:
					loser.roll_damage()
					
				winner.destination = null
			#if !description.subtype != "transfer":
			#	data_out(data)
		
	for side in Global.arr.side:
		if !fixed.has(side):
			var gladiator = get(side)
			gladiator.stamina.make_an_effort(Global.dict.effort[gladiator.stamina.effort])
	
	#next_reaction()


func data_out(data_: Dictionary) -> void:
	var text = data_.gladiator.team.status + " " + str(data_.gladiator.marker.order)
	
	match data_.subtype:
		"movement":
			text += " moved to " + str(data_.gladiator.marker.spot.grid)
		"movement":
			text += " get damage " + data_.damage
	
	print(text)


func next_reaction() -> void:
	if reaction != null:
		reaction.reset()
	
	if !reactions.is_empty():
		var b = reactions.size()
		reaction = reactions.pop_front()
		var a = reactions.size()
		set_reaction(reaction)
		
	else:
		end_of_encounter()


func set_reaction(clash_: Sprite2D) -> void:
	kind = "reaction"
	winner = null
	loser = null
	
	for result in results:
		if result.side == "right": 
			results.erase(result)
	
	leftPool.fixed = true
	fixed = ["left"]
	rightPool.reset()
	right = clash_.spots.defense.marker.gladiator
	
	right.choose_reaction()
	
	var input = {}
	input.type = "action"
	input.subtype = reaction.action
	reactionIcon.set_attributes(input)
	reactionIcon.visible = true
	
	update_side_icons("right")
	roll_pool()


func end_of_encounter() -> void:
#	var description = Global.dict.action.title[initiation.action]
#
#	match description.subtype:
#		"movement":
	
	initiation.reset()
	reset()
	stadium.next_clash()


func reset() -> void:
	winner = null
	loser = null
	results = []
	fixed = []
	leftPool.reset()
	rightPool.reset()
	reactionIcon.visible = false
