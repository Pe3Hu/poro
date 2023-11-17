extends MarginContainer


@onready var spots = $Spots
@onready var clashs = $Clashs
@onready var paths = $Paths
@onready var markers = $Markers

var stadium = null
var grids = {} 
var side = null


func set_attributes(input_: Dictionary) -> void:
	stadium = input_.stadium
	side = "left"
	
	init_grids()
	init_spots()
	init_clashs()
	init_paths()
	init_markers()
	place_markers()
	
	custom_minimum_size = Vector2(Global.num.field.cols + 1.0 / 3, Global.num.field.rows) * Global.vec.size.spot
	spots.position += Vector2(Global.num.spot.w, Global.num.spot.h) * 0.5
	#markers.position += Vector2(Global.num.spot.w, Global.num.spot.h) * 0.5
	
	set_visible_side(side)


func init_grids() -> void:
	grids = {}
	grids.spot = {}
	
	for index in Global.dict.spot.index:
		var description = Global.dict.spot.index[index]
		
		if !grids.has(description.side):
			grids[description.side] = {}
		
		if !grids[description.side].has(description.role):
			grids[description.side][description.role] = []
		
		grids[description.side][description.role].append(description.grid)


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
	for side_ in Global.dict.clash.side:
		for data in Global.dict.clash.side[side_]:
			var input = {}
			input.field = self
			input.side = side_
			input.spots = {}
			input.spots.attack = grids.spot[data.attack]
			input.spots.defense = grids.spot[data.defense]
			
			var clash = Global.scene.clash.instantiate()
			clashs.add_child(clash)
			clash.set_attributes(input)


func init_paths() -> void:
	for side_ in Global.dict.path.side:
		for grids_ in Global.dict.path.side[side_]:
			var input = {}
			input.field = self
			input.side = side_
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


func set_visible_side(side_: String) -> void:
	for spot in spots.get_children():
		spot.set_color_based_on_side(side_)
		
	for clash in clashs.get_children():
		clash.visible = clash.side == side_
	
	for path in paths.get_children():
		path.visible = path.side == side_


#func get_spot_based_on_grid() -> Polygon2D:
#	var spot = null
#
#
#	return spot
