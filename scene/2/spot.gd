extends Sprite2D


var field = null
var marker = null
var clash = null
var grid = null
var center = null
var declaration = null
var clashes = {}
var neighbors = {}
var layers = {}
var verge = null


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	
	set_gird(input_.grid)
	
	if remove_check():
		field.spots.remove_child(self)
		queue_free()
		return
	
	field.grids.spot[grid] = self
	update_based_on_side()
	
	for side in Global.arr.side:
		neighbors[side] = []


func set_gird(grid_: Vector2) -> void:
	grid = grid_
	var shift = Vector2()
	
	if int(grid.x) % 2 == 1:
		shift.y += 0.5
	
	position = (grid + shift) * Global.vec.size.spot
	center = position + Vector2(Global.num.spot.w, Global.num.spot.h) * 0.5
	
	for side in Global.dict.spot.grid[grid]:
		layers[side] = Global.dict.spot.grid[grid][side].layer
		verge = Global.dict.spot.grid[grid][side].verge


func remove_check() -> bool:
	for side in Global.arr.side:
		if field.grids[side].goal.front() == grid:
			return false
		
		if field.grids[side].attack.has(grid):
			return false
		
		if field.grids[side].defense.has(grid):
			return false
	
	return true


func update_based_on_side() -> void:
	visible = true
	var key = null
	
	if marker != null:
		if marker.carrier:
			key = "ball"
	
	if key == null:
		if field.grids[field.side].goal.front() == grid:
			key = "goal"

		if field.grids[field.side].attack.has(grid):
			key = "attack"

		if field.grids[field.side].defense.has(grid):
			key = "defense"
	
	if key != null:
		var path = "res://asset/png/icon/hex/" + key + ".png"
		texture = load(path)
		
		if scale == Vector2.ONE:
			scale = Global.vec.size.hex / Vector2(texture.get_width(), texture.get_height())
	else:
		visible = false


func add_clash(clash_: Node2D) -> void:
	if !clashes.has(clash_.side):
		clashes[clash_.side] = {}
	
	if !clashes[clash_.side].has(clash_):
		clashes[clash_.side][clash_] = clash_.get_opponent_spot(self)


func check_carrier_is_neighbor() -> bool:
	for neighbor in neighbors[field.side]:
		if neighbor.marker != null:
			if neighbor.marker.carrier:
				return true
	
	return false


func get_neighbor_carrier() -> Variant:
	for neighbor in neighbors[field.side]:
		if neighbor.marker != null:
			if neighbor.marker.carrier:
				return neighbor
	
	return null


func check_trigger(trigger_: Dictionary) -> bool:
	var flag = true
	
	if trigger_.has("layer"):
		if trigger_.layer != -1:
			flag = flag and trigger_.layer == layers[field.side]
		
	if trigger_.has("verge"):
		if trigger_.layer != -1:
			flag = flag and trigger_.verge == verge
	
	if trigger_.subject != "teamate":
		if trigger_.has("carrier"):
			flag = flag and marker.carrier == trigger_.carrier
	
	return flag
