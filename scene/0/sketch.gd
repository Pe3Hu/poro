extends MarginContainer


@onready var cradle = $HBox/Cradle
@onready var championship = $Championship


func _ready() -> void:
#	var input = {}
#	input.parent = self
#
#	var child = Global.scene.child.instantiate()
#	childs.add_child(child)
#	child.set_attributes(input)
	
	var input = {}
	input.sketch = self
	cradle.set_attributes(input)
	championship.set_attributes(input)
