class_name PlayerStand
extends PlayerState


## Maximum speed, in pixel/s
@export var max_speed: float = 256

## Time to max speed, in seconds
@export var acceleration: float = 1.0

## Time to 0 speed, in seconds
@export var deceleration: float = 1.0

## Factor applied to acceleration when changing direction
@export var turn_factor: float = 1.0

## If true, instantly change direction while moving
@export var instant_turn: bool


func physics_update(delta: float) -> void:
	var h_dir := PlayerInputs.dir.x
	
	# ACCELERATION
	if h_dir != 0:
		var is_turning: bool = player.velocity.x != 0 and sign(player.velocity.x) != h_dir
		if instant_turn and is_turning:
			player.velocity.x *= -1
		else:
			player.velocity.x += h_dir * max_speed / acceleration * delta * (turn_factor if is_turning else 1.0)
		player.velocity.x = clamp(player.velocity.x, -max_speed, max_speed)
		player.dir = h_dir
	# DECELERATION
	elif player.velocity.x != 0:
		var h_vel_sign: int = sign(player.velocity.x)
		player.velocity.x = player.velocity.x - h_vel_sign * max_speed / deceleration * delta
		
		if sign(player.velocity.x) != h_vel_sign:
			player.velocity.x = 0
	
	if not player.is_on_floor():
		transition_to("Air")
