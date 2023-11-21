extends MarginContainer


@onready var spots = $Spots
@onready var clashes = $Clashes
@onready var paths = $Paths
@onready var markers = $Markers

var stadium = null
var grids = {} 
var side = null
var carrier = null


func set_attributes(input_: Dictionary) -> void:
	stadium = input_.stadium
	side = "right"
	
	init_grids()
	init_spots()
	init_clashes()
	init_paths()
	init_markers()
	set_visible_side()
	
	custom_minimum_size = Vector2(Global.num.field.cols + 1.0 / 3, Global.num.field.rows) * Global.vec.size.spot
	spots.position += Vector2(Global.num.spot.w, Global.num.spot.h) * 0.5


func init_grids() -> void:
	grids = {}
	grids.spot = {}
	
	for grid in Global.dict.spot.grid:
		for _side in Global.dict.spot.grid[grid]:
			var description = Global.dict.spot.grid[grid][_side]
			
			if !grids.has(_side):
				grids[_side] = {}
			
			if !grids[_side].has(description.role):
				grids[_side][description.role] = []
			
			grids[_side][description.role].append(grid)


func init_spots() -> void:
	for _i in Global.num.field.rows:
		for _j in Global.num.field.cols:
			var input = {}
			input.field = self
			input.grid = Vector2(_j, _i)
			
			if Global.dict.spot.grid.has(input.grid):
				var spot = Global.scene.spot.instantiate()
				spots.add_child(spot)
				spot.set_attributes(input)
	
	init_spot_neighbors()


func init_spot_neighbors() -> void:
	for _side in Global.dict.path.side:
		for path in Global.dict.path.side[_side]:
			for _i in path.size() - 1:
				var spot = grids.spot[path[_i]]
				var neighbor = grids.spot[path[_i + 1]]
				
				if !spot.neighbors[_side].has(neighbor):
					spot.neighbors[_side].append(neighbor)
					
				if !neighbor.neighbors[_side].has(spot):
					neighbor.neighbors[_side].append(spot)


func init_clashes() -> void:
	for _side in Global.dict.clash.side:
		for data in Global.dict.clash.side[_side]:
			var input = {}
			input.field = self
			input.side = _side
			input.spots = {}
			input.spots.attack = grids.spot[data.attack]
			input.spots.defense = grids.spot[data.defense]
			
			var clash = Global.scene.clash.instantiate()
			clashes.add_child(clash)
			clash.set_attributes(input)
	
	for _side in Global.arr.side:
		for role in grids[_side]:
			if role != "goal":
				for grid in grids[_side][role]:
					var input = {}
					var a = grids[_side][role]
					input.field = self
					input.side = _side
					input.spots = {}
					input.spots.attack = grids.spot[grid]
					input.spots.defense = grids.spot[grid]
					
					var clash = Global.scene.clash.instantiate()
					clashes.add_child(clash)
					clash.set_attributes(input)
					grids.spot[grid].clash = clash


func init_paths() -> void:
	for _side in Global.dict.path.side:
		for grids_ in Global.dict.path.side[_side]:
			var input = {}
			input.field = self
			input.side = _side
			input.spots = []
			
			for grid in grids_:
				input.spots.append(grids.spot[grid])
			
			var path = Global.scene.path.instantiate()
			paths.add_child(path)
			path.set_attributes(input)


func init_markers() -> void:
	for team in stadium.teams:
		for _i in team.mains.size():
			var input = {}
			input.field = self
			input.order = _i + 1
			input.gladiator = team.mains[_i]
			
			var marker = Global.scene.marker.instantiate()
			markers.add_child(marker)
			marker.set_attributes(input)


func place_markers() -> void:
	for team in stadium.teams:
		for _i in team.mains.size():
			var marker = team.mains[_i].marker


func set_visible_side() -> void:
	for spot in spots.get_children():
		spot.update_based_on_side()
		
	for clash in clashes.get_children():
		clash.visible = false#clash.side == side
	
	for path in paths.get_children():
		path.visible = path.side == side


func switch_side() -> void:
	side = Global.dict.mirror.side[side]
	set_visible_side()


func get_clash_based_on_spots(spots_: Array) -> Variant:
	for clash in clashes.get_children():
		if clash.side == side:
			if (spots_.front() == clash.spots.attack and spots_.back() == clash.spots.defense) or (spots_.back() == clash.spots.attack and spots_.front() == clash.spots.defense):
				return clash
	
	return null
