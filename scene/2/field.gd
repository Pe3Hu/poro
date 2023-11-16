extends Node2D


@onready var spots = $Spots

var stadium = null
var grids = {} 
var side = null


func set_attributes(input_: Dictionary) -> void:
	stadium = input_.stadium
	position += Vector2(20, 20)
	
	init_grids()
	init_spots()


func init_grids() -> void:
	grids = {}
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
	
#	init_spot_neighbors()
#
#
#func init_spot_neighbors() -> void:
#	for spots in arr.spot:
#		for spot in spots:
#			for direction in Global.arr.neighbor[spot.num.parity]:
#				var grid = spot.vec.grid + direction
#
#					if check_border(grid):
#						var neighbor = arr.spot[grid.y][grid.x]
#						spot.dict.neighbor[neighbor] = direction
