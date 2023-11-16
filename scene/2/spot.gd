extends Polygon2D


var field = null
var grid = null


func set_attributes(input_: Dictionary) -> void:
	field = input_.field
	
	set_gird(input_.grid)
	init_vertexs()
	update_color()


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


func update_color() -> void:
	#left right
	if field.grids.right.goal == grid:
		color = Global.color.spot.goal
		return
	
	if field.grids.right.attacks.has(grid):
		color = Global.color.spot.attack
		return
	
	if field.grids.right.defenses.has(grid):
		color = Global.color.spot.defense
		return
	
	visible = false
