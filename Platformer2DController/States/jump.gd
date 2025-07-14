class_name PlayerJump
extends PlayerMove


## Jumping speed, in pixel / s
@export var jumping_speed: float = -512.0

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
	player.velocity.y = jumping_speed
	
	if not timer < min_time and (not Input.is_action_pressed("jump") or timer >= max_time):
		transition_to("Air")
