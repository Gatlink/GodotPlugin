class_name CameraTarget
extends Node2D


@export var change_dir_duration: float = 1.0


@onready var player: Player = get_tree().get_first_node_in_group("Player")


var offset: Vector2
var dir_timer: float
var last_dir: float = 1.0


func _ready() -> void:
	if player == null:
		printerr("CameraTarget could not find any Player")
		set_process(false)
	
	offset = global_position - player.global_position


func _process(delta: float) -> void:
	var new_dir := player.dir
	if new_dir != last_dir:
		dir_timer = change_dir_duration - dir_timer
	elif dir_timer > 0:
		dir_timer -= delta
	else:
		dir_timer = 0.0
	
	var dir: float = lerp(-new_dir, new_dir, 1.0 - dir_timer / change_dir_duration)
	global_position = player.global_position + Vector2(dir, 1) * offset
	last_dir = new_dir
