extends Node


const INPUT_BUFFER: float = 0.2


var dir := Vector2.ZERO
var jump_timer: float
var is_jumping: bool


var jumped: bool :
	get:
		return jump_timer > 0


func _process(delta: float) -> void:
	dir.x = Input.get_axis("left", "right")
	
	if Input.is_action_just_pressed("jump"):
		jump_timer = INPUT_BUFFER
	elif jump_timer > 0:
		jump_timer -= delta
	
	is_jumping = Input.is_action_pressed("jump")
