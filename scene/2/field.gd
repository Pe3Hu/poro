extends MarginContainer


@onready var spots = $Spots
@onready var clashs = $Clashs
@onready var paths = $Paths

var stadium = null
var grids = {} 
var side = null


func set_attributes(input_: Dictionary) -> void:
	stadium = input_.stadium
	
	init_grids()
	init_spots()
	init_clashs()
	init_paths()
	
	custom_minimum_size = Vector2(Global.num.field.cols + 1.0 / 3, Global.num.field.rows) * Global.vec.size.spot
	spots.position += Vector2(Global.num.spot.w, Global.num.spot.h) * 0.5
	
	var spot = grids.spots[Vector2(10, 3)]
	
	var side = "right"
	
#	for side_ in spot.clashs:
#		if side_ == side:
#			for clash in spot.clashs[side_]:
#				var opponent = spot.clashs[side_][clash]
#				opponent.visible = false
	
	set_visible_side(side)


func init_grids() -> void:
	grids = {}
	grids.spots = {}
	grids.left = {}
	grids.left.goal = Vector2(0, 3)
	grids.left.attacks = []
	grids.left.attacks.append(Vector2(2, 3))
	grids.left.attacks.append(Vector2(6, 1))
	grids.left.attacks.append(Vector2(6, 3))
	grids.left.attacks.append(Vector2(6, 5))
	grids.left.attacks.append(Vector2(10, 0))
	grids.left.attacks.append(Vector2(10, 2))
	grids.left.attacks.append(Vector2(10, 4))
	grids.left.attacks.append(Vector2(10, 6))
	grids.left.attacks.append(Vector2(12, 1))
	grids.left.attacks.append(Vector2(12, 5))
	grids.left.defenses = []
	grids.left.defenses.append(Vector2(4, 2))
	grids.left.defenses.append(Vector2(4, 4))
	grids.left.defenses.append(Vector2(8, 0))
	grids.left.defenses.append(Vector2(8, 2))
	grids.left.defenses.append(Vector2(8, 4))
	grids.left.defenses.append(Vector2(8, 6))
	
	grids.right = {}
	var center = Vector2(6, 3)
	
	for key in grids.left:
		if key == "goal":
			grids.right[key] = center + (center - grids.left[key])
		else:
			grids.right[key] = []
			
			for _i in grids.left[key].size():
				var vector = grids.left[key][_i]
				var x = center.x + (center.x - grids.left[key][_i].x)
				var grid = Vector2(x, vector.y)
				grids.right[key].append(grid)


func init_spots() -> void:
	for _i in Global.num.field.rows:
		for _j in Global.num.field.cols:
			var input = {}
			input.field = self
			input.grid = Vector2(_j, _i)
	
			var spot = Global.scene.spot.instantiate()
			spots.add_child(spot)
			spot.set_attributes(input)


func init_clashs() -> void:
	for side in Global.dict.clash.side:
		for data in Global.dict.clash.side[side]:
			var input = {}
			input.field = self
			input.side = side
			input.spots = {}
			input.spots.attack = grids.spots[data.attack]
			input.spots.defense = grids.spots[data.defense]
			
			var clash = Global.scene.clash.instantiate()
			clashs.add_child(clash)
			clash.set_attributes(input)


func init_paths() -> void:
	for side in Global.dict.path.side:
		for grids_ in Global.dict.path.side[side]:
			var input = {}
			input.field = self
			input.side = side
			input.spots = []
			
			for grid in grids_:
				input.spots.append(grids.spots[grid])
			
			var path = Global.scene.path.instantiate()
			paths.add_child(path)
			path.set_attributes(input)


func set_visible_side(side_: String) -> void:
	for spot in spots.get_children():
		spot.set_color_based_on_side(side_)
		
	for clash in clashs.get_children():
		clash.visible = clash.side == side_
	
	for path in paths.get_children():
		path.visible = path.side == side_
