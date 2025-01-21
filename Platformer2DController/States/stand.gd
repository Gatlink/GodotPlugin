class_name PlayerStand
extends PlayerState


## Maximum speed, in pixel/s
@export var max_speed: float = 256

## Time to max speed, in seconds
@export var acceleration: float = 1.0

## Time to 0 speed, in seconds
@export var deceleration: float = 1.0

## If true, instantly change direction while moving
@export var instant_turn: bool


func physics_update(delta: float) -> void:
	var h_dir := PlayerInputs.dir.x
	
	# ACCELERATION
	if h_dir != 0:
		if instant_turn and player.velocity.x != 0 and sign(player.velocity.x) != h_dir:
			player.velocity.x *= -1
		else:
			player.velocity.x += h_dir * max_speed / acceleration * delta
		player.velocity.x = clamp(player.velocity.x, -max_speed, max_speed)
		player.dir = h_dir
	# DECELERATION
	elif player.velocity.x != 0:
		var h_vel_sign: int = sign(player.velocity.x)
		player.velocity.x = player.velocity.x - h_vel_sign * max_speed / deceleration * delta
		
		if sign(player.velocity.x) != h_vel_sign:
			player.velocity.x = 0
