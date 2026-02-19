extends Node


const INPUT_BUFFER: float = 0.2


var dir := Vector2.ZERO
var actions: Dictionary = {}
var freeze_dir: bool


func _ready() -> void:
	for action in InputMap.get_actions():
		actions[action] = {
			"timer": 0.0,
			"pressed": false,
			"consumed": false
		}


func _process(delta: float) -> void:
	dir.x = Input.get_axis("left", "right") if not freeze_dir else 0.0
	
	for action in actions.keys():
		if Input.is_action_just_pressed(action):
			actions[action].timer = INPUT_BUFFER
			actions[action].consumed = false
		elif actions[action].timer > 0:
			actions[action].timer -= delta
		
		actions[action].pressed = Input.is_action_pressed(action)


func is_pressed(action: String) -> bool:
	return actions.has(action) and actions[action].pressed


func is_just_pressed(action: String) -> bool:
	if actions.has(action) and actions[action].timer > 0 and not actions[action].consumed:
		actions[action].consumed = true
		return true
	
	return false
