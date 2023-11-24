extends MarginContainer


@onready var bar = $ProgressBar
@onready var value = $Value

var stamina = null
var state = null


func set_attributes(input_: Dictionary) -> void:
	stamina = input_.stamina
	state = input_.state
	bar.max_value = input_.max
	custom_minimum_size = Vector2(Global.vec.size.bar)
	custom_minimum_size.x *= bar.max_value / stamina.value.total
	set_colors()


func set_colors() -> void:
	var keys = ["fill", "background"]
	bar.value = bar.max_value
	
	for key in keys:
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Global.color.stamina[state][key]
		var path = "theme_override_styles/" + key
		bar.set(path, style_box)


func update_value(value_: String, shift_: int) -> void:
	match value_:
		"current":
			bar.value += shift_
			visible = true
			
			if bar.value < 0:
				stamina.update_state()
				stamina.make_an_effort(-bar.value)
				bar.value = 0
				visible = false
			
			value.text = str(bar.value)
		"maximum":
			bar.max_value += shift_


func get_percentage() -> int:
	return floor(bar.value * 100 / bar.max_value)


func reset() -> void:
	bar.value = bar.max_value
