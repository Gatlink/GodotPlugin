class_name PlayerMove
extends PlayerState

@export_category("Horizontal Movement")

## Maximum speed, in pixel/s
@export var max_speed: float = 256

## Time to max speed, in seconds
@export var time_to_full_speed: float = 1.0

## Time to 0 speed, in seconds
@export var time_to_stop: float = 1.0

## Factor applied to acceleration when changing direction
@export var turn_factor: float = 1.0

## If true, instantly change direction while moving
@export var instant_turn: bool


@onready var acceleration: float = max_speed / time_to_full_speed
@onready var deceleration: float = max_speed / time_to_stop


func physics_update(delta: float) -> void:
	var h_dir := PlayerInputs.dir.x
	var acc: float = deceleration
	var target_speed: float = 0.0
	
	if h_dir != 0:
		player.dir = h_dir
		target_speed = h_dir * max_speed
		var is_turning: bool = player.velocity.x != 0 and sign(player.velocity.x) != h_dir
		if is_turning:
			acc = acceleration * turn_factor if not instant_turn else INF
		else:
			acc = acceleration
	
	player.velocity.x = get_new_velocity_x(target_speed, acc, delta)


func get_new_velocity_x(target_speed: float, acc: float, delta: float) -> float:
	var diff: float = target_speed - player.velocity.x
	var dir: float = sign(diff)
	
	# Speed is already at target speed
	if dir == 0:
		return player.velocity.x
	
	var speed_delta: float = dir * acc * delta
	
	# prevent overshooting
	if abs(speed_delta) > abs(diff):
		speed_delta = diff
	
	return player.velocity.x + speed_delta
