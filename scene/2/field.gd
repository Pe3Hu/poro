extends MarginContainer


@onready var spots = $Spots
@onready var clashes = $Clashes
@onready var paths = $Paths
@onready var markers = $Markers
@onready var trajectory = $Trajectory

var stadium = null
var grids = {} 
var side = null
var carrier = null


func set_attributes(input_: Dictionary) -> void:
	stadium = input_.stadium
	side = "left"
	
	var input = {}
	input.field = self
	trajectory.set_attributes(input)
	
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


func get_all_routes_based_on_spots(spots_: Array) -> Array:
	var start = spots_.front()
	var end = spots_.back()
	var visited = [start]
	var data = {}
	data.parent = start
	data.child = start
	var datas = [[data]]
	var stop = false
	var _i = 0
	
	while !stop and _i < 6:
		_i += 1
		var previuos = datas.back()
		var next = []
		
		for _data in previuos:
			for neighbor in _data.child.neighbors[side]:
				if !visited.has(neighbor):
					data = {}
					data.parent = _data.child
					data.child = neighbor
					
					if !next.has(data):
						next.append(data)
					
					if end == neighbor:
						stop = true
		
		for _data in next:
			if !visited.has(_data.child):
				visited.append(_data.child)
		
		datas.append(next)
	
	_i = datas.size() - 1
	var mainlines = [end]
	var branches = []
	stop = false
	
	while !stop:
		for _data in datas[_i]:
			if mainlines.has(_data.child) and !mainlines.has(_data.parent):
				mainlines.append(_data.parent)
			
			if !mainlines.has(_data.child) and !branches.has(_data.parent):
				branches.append(_data.parent)
		
		for _j in range(branches.size()-1,-1,-1):
			var branch = branches[_j]
			
			if mainlines.has(branch):
				branches.erase(branch)
		
		for _j in range(datas[_i].size()-1,-1,-1):
			data = datas[_i][_j]
			
			if !mainlines.has(data.child):
				datas[_i].erase(data)
		
		branches = []
		_i -= 1
		
		if mainlines.has(start):
			stop = true
	
	var weights = {}
	
	for _j in datas.size() - 1:
		var parents = datas[_j]
		var childs = datas[_j + 1]
		
		for parent in parents:
			weights[parent.child.grid] = 0
			
			for child in childs:
				if child.parent == parent.child:
					weights[parent.child.grid] += 1
	
	_i = 1
	stop = false
	var routes = {}
	routes.previous = [[start]]
	routes.next = []
	
	while !stop:
		for _route in routes.previous:
			for _data in datas[_i]:
				if _data.parent == _route.back():
					var route = []
					route.append_array(_route)
					route.append(_data.child)
					routes.next.append(route)
					
					if _data.child == end:
						stop = true
		
		routes.previous = []
		routes.previous.append_array(routes.next)
		routes.next = []
		_i += 1
	print(weights)
	
	return routes
