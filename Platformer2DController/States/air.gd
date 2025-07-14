class_name PlayerAir
extends PlayerMove


## Max speed while falling, in pixel / s
@export var terminal_speed: float = 512.0

## Time to reach terminal velocity, in seconds
@export var gravity: float = 1.0

## Time after falling during which the player can jump, in seconds
@export var coyotee_time: float = 0.2


var coyotee_timer: float


func enter(params: Dictionary = {}) -> void:
	super(params)
	coyotee_timer = coyotee_time if params.has("has_coyotee_time") else 0.0


func physics_update(delta: float) -> void:
	super(delta)
	player.velocity.y = min(player.velocity.y + delta * terminal_speed / gravity, terminal_speed)
	
	if coyotee_timer > 0:
		coyotee_timer -= delta
		if PlayerInputs.jumped:
			transition_to("Jump")
	
	if player.is_on_floor():
		transition_to("Stand")
