extends Node


var rng = RandomNumberGenerator.new()
var arr = {}
var num = {}
var vec = {}
var color = {}
var dict = {}
var flag = {}
var node = {}
var scene = {}


func _ready() -> void:
	init_arr()
	init_num()
	init_vec()
	init_color()
	init_dict()
	init_node()
	init_scene()


func init_arr() -> void:
	arr.edge = [1, 2, 3, 4, 5, 6]
	arr.state = ["vigor", "standard", "fatigue"]
	arr.effort = ["peak", "normal", "minimum"]
	arr.aspect = ["strength", "dexterity"]
	arr.side = ["left", "right"]
	arr.role = ["attack", "defense"]
	arr.status = ["keeper", "guest"]


func init_num() -> void:
	num.index = {}
	
	num.spot = {}
	num.spot.r = 48
	num.spot.h = num.spot.r * sqrt(3)
	num.spot.w = num.spot.r * 2
	
	num.field = {}
	num.field.rows = 8
	num.field.cols = 13
	
	num.anchor = {}
	num.anchor.r = num.spot.r / 3
	
	num.team = {}
	num.team.markers = 6


func init_dict() -> void:
	init_neighbor()
	init_mirror()
	init_aspect()
	init_spot()
	init_clash()
	init_path()
	init_temperament()


func init_mirror() -> void:
	dict.mirror = {}
	dict.mirror.role = {}
	dict.mirror.role["attack"] = "defense"
	dict.mirror.role["defense"] = "attack"
	
	dict.mirror.side = {}
	dict.mirror.side["left"] = "rigth"
	dict.mirror.side["rigth"] = "left"
	
	dict.effort = {}
	dict.effort.peak = 5
	dict.effort.normal = 3
	dict.effort.minimum = 2


func init_neighbor() -> void:
	dict.neighbor = {}
	dict.neighbor.linear3 = [
		Vector3( 0, 0, -1),
		Vector3( 1, 0,  0),
		Vector3( 0, 0,  1),
		Vector3(-1, 0,  0)
	]
	dict.neighbor.linear2 = [
		Vector2( 0,-1),
		Vector2( 1, 0),
		Vector2( 0, 1),
		Vector2(-1, 0)
	]
	dict.neighbor.diagonal = [
		Vector2( 1,-1),
		Vector2( 1, 1),
		Vector2(-1, 1),
		Vector2(-1,-1)
	]
	dict.neighbor.zero = [
		Vector2( 0, 0),
		Vector2( 1, 0),
		Vector2( 1, 1),
		Vector2( 0, 1)
	]
	dict.neighbor.hex = [
		[
			Vector2( 1,-1), 
			Vector2( 1, 0), 
			Vector2( 0, 1), 
			Vector2(-1, 0), 
			Vector2(-1,-1),
			Vector2( 0,-1)
		],
		[
			Vector2( 1, 0),
			Vector2( 1, 1),
			Vector2( 0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2( 0,-1)
		]
	]


func init_aspect() -> void:
	dict.aspect = {}
	dict.aspect.rank = {}
	dict.aspect.reflection = {}
	dict.aspect.reflection["strength"] = "dexterity"
	dict.aspect.reflection["dexterity"] = "strength"
	
	var path = "res://asset/json/poro_aspect.json"
	var array = load_data(path)
	
	for aspect in array:
		aspect.rank = int(aspect.rank)
		var data = {}
		data.states = {}
		var predispositions = []
		
		for key in aspect:
			if key != "rank":
				
				if key == "predispositions":
					predispositions = str(aspect[key]).split("|")
				elif key != "rank":
					var words = []
					words = key.split(" ")
				
					if !data.states.has(words[0]):
						data.states[words[0]]= {}
					
					data.states[words[0]][words[1]] = aspect[key]
		
		dict.aspect.rank[aspect.rank] = {}
		dict.aspect.rank[aspect.rank].predispositions = {}
		dict.aspect.rank[aspect.rank].predispositions[10] = data
		
		for predisposition in predispositions:
			var value = int(predisposition)
			var multiplier = int(predisposition) / 10.0
			var description = dict.aspect.rank[aspect.rank].predispositions[10]
			
			dict.aspect.rank[aspect.rank].predispositions[value] = {}
			dict.aspect.rank[aspect.rank].predispositions[value].states = {}

			for state in description.states:
				dict.aspect.rank[aspect.rank].predispositions[value].states[state] = {}
				for effort in description.states[state]:
					dict.aspect.rank[aspect.rank].predispositions[value].states[state][effort] = ceil(description.states[state][effort] * multiplier)


func init_spot() -> void:
	dict.spot = {}
	dict.spot.index = {}
	
	var path = "res://asset/json/poro_spot.json"
	var array = load_data(path)
	
	for spot in array:
		var data = {}
		data.grid = Vector2()
		
		for key in spot:
			if key != "index":
				var words = []
				words = key.split(" ")
				
				if words.has("grid"):
					data.grid[words[1]] = spot[key]
					
					data[words[0]][words[1]] = spot[key]
				elif words.has("layer"):
					data.layer = spot[key]
				else:
					data.side = words[0]
					data.role = words[1]
					data.order = spot[key]
				
		dict.spot.index[int(spot.index)] = data


func init_clash() -> void:
	dict.clash = {}
	dict.clash.side = {}
	
	var path = "res://asset/json/poro_clash.json"
	var array = load_data(path)
	
	for clash in array:
		if !dict.clash.side.has(clash.side):
			dict.clash.side[clash.side] = []
		
		var data = {}
		
		for key in clash:
			if key != "index" and key != "side":
				var words = []
				words = key.split(" ")
				
				if !data.has(words[0]):
					data[words[0]] = Vector2()
				
				data[words[0]][words[1]] += clash[key]
		
		dict.clash.side[clash.side].append(data)


func init_path() -> void:
	dict.path = {}
	dict.path.side = {}
	
	var path_ = "res://asset/json/poro_path.json"
	var array = load_data(path_)
	
	for path in array:
		if !dict.path.side.has(path.side):
			dict.path.side[path.side] = []
		
		var data = {}
		data.indexs = {}
		data.grids = []
		
		for key in path:
			if key != "index" and key != "side":
				var words = []
				words = key.split(" ")
				
				if !data.indexs.has(words[0]):
					data.indexs[words[0]] = Vector2()
				
				data.indexs[words[0]][words[1]] += path[key]
		
		for index in data.indexs:
			var grid = Vector2(data.indexs[index].x, data.indexs[index].y)
			data.grids.append(grid)
		
		dict.path.side[path.side].append(data.grids)


func init_temperament() -> void:
	dict.temperament = {}
	dict.temperament.title = {}
	
	var path = "res://asset/json/poro_temperament.json"
	var array = load_data(path)
	
	for temperament in array:
		var data = {}
		data.chances = {}
		
		for key in temperament:
			if key != "title":
				var words = []
				words = key.split(" ")
				
				if arr.state.has(words[0]):
					if !data.chances.has(words[0]):
						data.chances[words[0]] = {}
					
					data.chances[words[0]][words[1]] = temperament[key]
				else:
					data[key] = temperament[key]
		
		dict.temperament.title[temperament.title] = data


func init_node() -> void:
	node.game = get_node("/root/Game")


func init_scene() -> void:
	scene.icon = load("res://scene/0/icon.tscn")
	
	scene.team = load("res://scene/1/team.tscn")
	scene.gladiator = load("res://scene/1/gladiator.tscn")
	scene.performance = load("res://scene/1/performance.tscn")
	
	scene.tournament = load("res://scene/2/tournament.tscn")
	scene.stadium = load("res://scene/2/stadium.tscn")
	scene.spot = load("res://scene/2/spot.tscn")
	scene.clash = load("res://scene/2/clash.tscn")
	scene.path = load("res://scene/2/path.tscn")
	scene.marker = load("res://scene/2/marker.tscn")
	


func init_vec():
	vec.size = {}
	vec.size.letter = Vector2(20, 20)
	vec.size.icon = Vector2(48, 48)
	vec.size.number = Vector2(5, 32)
	
	vec.size.marker = Vector2(64, 64) * 0.75
	vec.size.hex = Vector2(64, 64) * 1.66
	vec.size.action = Vector2(64, 64) * 0.75
	vec.size.spot = Vector2(num.spot.w * 0.75, num.spot.h)
	
	init_window_size()


func init_window_size():
	vec.size.window = {}
	vec.size.window.width = ProjectSettings.get_setting("display/window/size/viewport_width")
	vec.size.window.height = ProjectSettings.get_setting("display/window/size/viewport_height")
	vec.size.window.center = Vector2(vec.size.window.width/2, vec.size.window.height/2)


func init_color():
	var h = 360.0
	
	color.indicator = {}
	color.indicator.health = {}
	color.indicator.health.fill = Color.from_hsv(0, 1, 0.9)
	color.indicator.health.background = Color.from_hsv(0, 0.25, 0.9)
	color.indicator.endurance = {}
	color.indicator.endurance.fill = Color.from_hsv(0.33, 1, 0.9)
	color.indicator.endurance.background = Color.from_hsv(0.33, 0.25, 0.9)
	color.indicator.barrier = {}
	color.indicator.barrier.fill = Color.from_hsv(0.5, 1, 0.9)
	color.indicator.barrier.background = Color.from_hsv(0.5, 0.25, 0.9)
	
	color.spot = {}
	color.spot.attack = Color.from_hsv(0.0 / h, 0.8, 0.9)
	color.spot.defense = Color.from_hsv(210.0 / h, 0.8, 0.9)
	color.spot.goal = Color.from_hsv(270.0 / h, 0.8, 0.9)
	
	color.anchor = Color.from_hsv(120.0 / h, 0.8, 0.9)


func save(path_: String, data_: String):
	var path = path_ + ".json"
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(data_)


func load_data(path_: String):
	var file = FileAccess.open(path_, FileAccess.READ)
	var text = file.get_as_text()
	var json_object = JSON.new()
	var parse_err = json_object.parse(text)
	return json_object.get_data()


func get_random_key(dict_: Dictionary):
	if dict_.keys().size() == 0:
		print("!bug! empty array in get_random_key func")
		return null
	
	var total = 0
	
	for key in dict_.keys():
		total += dict_[key]
	
	rng.randomize()
	var index_r = rng.randf_range(0, 1)
	var index = 0
	
	for key in dict_.keys():
		var weight = float(dict_[key])
		index += weight/total
		
		if index > index_r:
			return key
	
	print("!bug! index_r error in get_random_key func")
	return null
