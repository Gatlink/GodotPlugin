class_name CameraTarget
extends Node2D


## The minimum x pos on the screen the player can go before the camera moves, in percentage
@export var screen_pos_min: float = 0.15

## The maximum x pos on the screen the player can go before the camera moves, in percentage
@export var screen_pos_max: float = 0.35

## The difference on the y axis between the position of the player and the position of the camera, in pixels
@export var offset_y: float = -114.0

## How fast the camera target will go from its current position to its desired position
@export var smoothing: float = 3.0

## The distance the players need to fall before the camera start following him down, in pixels
@export var fall_distance_limit: float = 256.0


@onready var player: Player = get_tree().get_first_node_in_group("Player")


var limits: Vector2
var offset_x: float
var is_right_facing: bool = true
var desired_position: Vector2
var follow_fall: bool


func _ready() -> void:
	if player == null:
		printerr("CameraTarget could not find any Player")
		set_process(false)
	
	var viewport_rect := get_viewport_rect()
	offset_x = viewport_rect.size.x * (0.5 - screen_pos_max)
	desired_position = global_position


func _process(delta: float) -> void:
	compute_limits()
	#queue_redraw()
	
	if player.global_position.x >= limits.y:
		desired_position.x = player.global_position.x + offset_x
		is_right_facing = true
	elif player.global_position.x <= limits.x:
		desired_position.x = player.global_position.x - offset_x
		is_right_facing = false
	
	if player.is_on_floor():
		desired_position.y = player.global_position.y + offset_y
		follow_fall = false
	elif follow_fall:
		desired_position.y = player.global_position.y - offset_y
	elif player.global_position.y - desired_position.y >= fall_distance_limit:
		follow_fall = true
	
	global_position = lerp(global_position, desired_position, smoothing * delta)


func compute_limits() -> void:
	var viewport_rect := get_viewport_rect()
	var camera_pos_x := get_viewport().get_camera_2d().global_position.x
	var min_limit := screen_pos_min if is_right_facing else 1.0 - screen_pos_max
	var max_limit := screen_pos_max if is_right_facing else 1.0 - screen_pos_min
	limits = Vector2(
		camera_pos_x + viewport_rect.size.x * (min_limit - 0.5),
		camera_pos_x + viewport_rect.size.x * (max_limit- 0.5)
	)


#func _draw() -> void:
	#draw_limit(limits.x)
	#draw_limit(limits.y)


#func draw_limit(x: float) -> void:
	#draw_line(
		#to_local(Vector2(x, global_position.y - 32)),
		#to_local(Vector2(x, global_position.y + 32)),
		#Color.RED
	#)
