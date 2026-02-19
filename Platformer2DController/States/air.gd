class_name PlayerAir
extends PlayerMove

@export_category("Falling")

## Max speed while falling, in pixel / s
@export var terminal_speed: float = 512.0

## Time to reach terminal speed from a speed of 0, in pixels / seconds^2
@export var fall_gravity: float = 512.0

@export_category("Jumping")

## Different possible jumps as JumpData
@export var jumps: Array[JumpData]

## Time after falling during which the player can jump, in seconds
@export var coyotee_time: float = 0.2


var coyotee_timer: float
var was_cutoff: bool
var jump_data: JumpData
var starting_y: float


func init_jump(data: JumpData) -> void:
	player.velocity.y = -sqrt(data.max_height * 2.0 * data.gravity)
	coyotee_timer = 0.0
	was_cutoff = false
	jump_data = data
	player.velocity.x = max(data.initial_h_speed, abs(player.velocity.x)) * player.dir
	
	if jump_data.is_dir_frozen:
		PlayerInputs.freeze_dir = true


func get_jump_data(id: String) -> JumpData:
	for data in jumps:
		if data.id == id:
			return data
	
	printerr("Could not find jump data for ", id)
	return jumps[0]


func enter(params: Dictionary = {}) -> void:
	super(params)
	if params.has("jump"):
		var data := get_jump_data(params.jump)
		init_jump(data)
	else:
		coyotee_timer = coyotee_time
		jump_data = null
	
	was_cutoff = false
	player.play_animation("jump")
	starting_y = player.global_position.y


func exit() -> void:
	super()
	PlayerInputs.freeze_dir = false


func physics_update(delta: float) -> void:
	super(delta)
	
	var is_jumping := player.velocity.y < 0
	if is_jumping and jump_data != null and not was_cutoff and not PlayerInputs.is_pressed("jump"):
		was_cutoff = true
	
	if not is_jumping and PlayerInputs.freeze_dir:
		PlayerInputs.freeze_dir = false
	
	var gravity := jump_data.gravity if jump_data != null and is_jumping else fall_gravity
	if was_cutoff and is_jumping:
		gravity *= jump_data.cutoff
	
	player.velocity.y = min(player.velocity.y + delta * gravity, terminal_speed)
	
	player.play_animation("jump")
	
	if PlayerInputs.is_just_pressed("jump") and coyotee_timer > 0:
		init_jump(get_jump_data("long_jump" if state_machine.prev_state == "Roll" else "running_jump"))
	elif player.is_on_floor():
		transition_to("Stand")
	
	if coyotee_timer > 0:
		coyotee_timer -= delta
