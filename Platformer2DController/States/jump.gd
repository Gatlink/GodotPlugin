class_name PlayerJump
extends PlayerMove


## Maximum height of the jump, in pixels
@export var max_height: float = 128.0

## Minimum time spent jumping, in seconds
@export var min_time: float = 0

## Max time the input can be pressed, in seconds
@export var max_time: float = 0.5


var timer: float


func enter(params: Dictionary = {}) -> void:
	super(params)
	
	timer = 0


func physics_update(delta: float) -> void:
	super(delta)
	
	timer += delta
	player.velocity.y = -max_height / max_time
	
	if not timer < min_time and (not PlayerInputs.is_jumping or timer >= max_time):
		transition_to("Air")
