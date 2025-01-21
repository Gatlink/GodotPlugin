class_name PlayerState
extends State


var player : Player


func _ready() -> void:
	await owner.ready
	
	var parent = get_parent()
	while parent != null and !(parent is Player):
		parent = parent.get_parent()
	
	player = parent
