class_name PlayerAir
extends PlayerMove


## Max speed while falling, in pixel / s
@export var terminal_speed: float = 512.0

## Time to reach terminal velocity, in seconds
@export var gravity: float = 1.0


func physics_update(delta: float) -> void:
	super(delta)
	player.velocity.y = min(player.velocity.y + delta * terminal_speed / gravity, terminal_speed)
	
	if player.is_on_floor():
		transition_to("Stand")
