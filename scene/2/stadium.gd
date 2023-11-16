extends MarginContainer


@onready var field = $Field
@onready var markers = $Markers

var tournament = null
var cell = null
var offset = null


func set_attributes(input_: Dictionary) -> void:
	tournament  = input_.tournament
	
	var input = {}
	input.stadium = self
	field.set_attributes(input)
	#cell.y = cell.x * sqrt(3) / 2
	offset = Vector2()#Vector2(cell.x * 0.125, cell.y * 0.25)#9.0 / 32
	
	#var input = {}
	input.stadium = self
	input.gladiator = null
	input.grid = Vector2(0, 0)
	#var cells = left.get_used_cells(0)
	#var a = left.map_to_local(input.grid)
	#var b = Vector2.to_global(a)
	#print(cell)
	#add_marker(input)


func add_marker(input_: Dictionary) -> void:
	var marker = Global.scene.marker.instantiate()
	markers.add_child(marker)
	marker.set_attributes(input_)
	print(marker.position)
