extends TileMap


var stadium = null
var grids = {} 
var side = null


func set_attributes(input_: Dictionary) -> void:
	stadium = input_.stadium
	stadium.cell = tile_set.tile_size * scale.x
	switch_side()


func switch_side() -> void:
	grids = {}
	grids.left = {}
	grids.left.goal = Vector2(1, 4)
	grids.left.attacks = []
	grids.left.attacks.append(Vector2(3, 4))
	grids.left.attacks.append(Vector2(7, 2))
	grids.left.attacks.append(Vector2(7, 4))
	grids.left.attacks.append(Vector2(7, 6))
	grids.left.attacks.append(Vector2(11, 1))
	grids.left.attacks.append(Vector2(11, 3))
	grids.left.attacks.append(Vector2(11, 5))
	grids.left.attacks.append(Vector2(11, 7))
	grids.left.attacks.append(Vector2(13, 2))
	grids.left.attacks.append(Vector2(13, 6))
	grids.left.defenses = []
	grids.left.defenses.append(Vector2(5, 5))
	grids.left.defenses.append(Vector2(5, 5))
	grids.left.defenses.append(Vector2(9, 1))
	grids.left.defenses.append(Vector2(9, 3))
	grids.left.defenses.append(Vector2(9, 5))
	grids.left.defenses.append(Vector2(9, 7))
	
	grids.right = {}
	pass
