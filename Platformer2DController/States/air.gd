class_name PlayerAir
extends PlayerMove

@export_category("Falling")

## Max speed while falling, in pixel / s
@export var terminal_speed: float = 512.0

## Time to reach terminal speed from a speed of 0, in pixels / seconds^2
@export var fall_gravity: float = 512.0

@export_category("Jumping")

## Maximum height of the jump, in pixels
@export var jump_max_height: float = 192.0

## Gravity while jumping
@export var jump_gravity: float = 512.0

## Applied to gravity if the jump button is released early
@export var jump_cutoff: float = 2.0

## Time after falling during which the player can jump, in seconds
@export var coyotee_time: float = 0.2


var coyotee_timer: float
var was_cutoff: bool


func init_jump() -> void:
	player.velocity.y = -sqrt(jump_max_height * 2.0 * jump_gravity)
	coyotee_timer = 0.0
	was_cutoff = false


func enter(params: Dictionary = {}) -> void:
	super(params)
	if params.has("jump"):
		init_jump()
	else:
		coyotee_timer = coyotee_time
	
	player.play_animation("jump")


func physics_update(delta: float) -> void:
	super(delta)
	
	var is_jumping := player.velocity.y < 0.0
	if is_jumping and not was_cutoff and not PlayerInputs.is_jumping:
		was_cutoff = true
	
	var gravity := jump_gravity if is_jumping else fall_gravity
	if was_cutoff:
		gravity *= jump_cutoff
	
	player.velocity.y = min(player.velocity.y + delta * gravity, terminal_speed)
	
	if coyotee_timer > 0:
		coyotee_timer -= delta
		if PlayerInputs.jumped:
			init_jump()
	
	if player.is_on_floor():
		transition_to("Stand")
