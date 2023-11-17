extends Polygon2D


var field = null
var grid = null
var center = null
var clashs = {}


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	
	set_gird(input_.grid)
	
	if remove_check():
		field.spots.remove_child(self)
		queue_free()
		return
	
	field.grids.spot[grid] = self
	init_vertexs()
	set_color_based_on_side("right")


func init_vertexs() -> void:
	var n = 6
	var vertexs = []
	var angle = PI * 2 / n
	
	for _i in n:
		var vertex = Vector2.from_angle(angle * _i) * Global.num.spot.r
		vertexs.append(vertex)
	
	set_polygon(vertexs)


func set_gird(grid_: Vector2) -> void:
	grid = grid_
	var shift = Vector2()
	
	if int(grid.x) % 2 == 1:
		shift.y += 0.5
	
	position = (grid + shift) * Global.vec.size.spot
	center = position + Vector2(Global.num.spot.w, Global.num.spot.h) * 0.5


func remove_check() -> bool:
	for side in Global.arr.side:
		if field.grids[side].goal.front() == grid:
			return false
		
		if field.grids[side].attack.has(grid):
			return false
		
		if field.grids[side].defense.has(grid):
			return false
	
	return true


func set_color_based_on_side(side_: String) -> void:
	visible = true
	
	if field.grids[side_].goal.front() == grid:
		color = Global.color.spot.goal
		#print("goal")
		return
	
	if field.grids[side_].attack.has(grid):
		#print("attack")
		color = Global.color.spot.attack
		return
	
	if field.grids[side_].defense.has(grid):
		#print("defense")
		color = Global.color.spot.defense
		return
	
	visible = false


func add_clash(clash_: Node2D) -> void:
	if !clashs.has(clash_.side):
		clashs[clash_.side] = {}
	
	clashs[clash_.side][clash_] = clash_.get_opponent(self)
