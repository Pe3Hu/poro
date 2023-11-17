extends Node


@onready var cradle = $Sketch/HBox/Cradle
@onready var championship = $Sketch/HBox/Championship


func _ready() -> void:
	#datas.sort_custom(func(a, b): return a.value < b.value)
	#012 description
	
	
	var input = {}
	input.game = self
	cradle.set_attributes(input)
	championship.set_attributes(input)
	pass


func _input(event) -> void:
	if event is InputEventKey:
		match event.keycode:
			KEY_SPACE:
				if event.is_pressed() && !event.is_echo():
					pass


#func _process(delta_) -> void:
#	$FPS.text = str(Engine.get_frames_per_second())
