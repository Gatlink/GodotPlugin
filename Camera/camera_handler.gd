class_name CameraHandler
extends Node2D


const TRAUMA_POWER = 2


@export var target_path : NodePath
@export var damp_time: float = 1.5

@export_category("Screen Shake")
@export var decay := 0.8
@export var max_offset := Vector2(100, 75)
@export var max_roll := 0.1


@onready var target : Node2D = get_node(target_path)
@onready var damping_timer : float
@onready var camera : Camera2D = $Camera2D
@onready var noise : FastNoiseLite = FastNoiseLite.new()


var followed_nodes : Array = []
var damped_pos : Vector2
var trauma : Vector2
var noise_y : int = 0
var is_first_damp: bool = true


func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.fractal_octaves = 2
	
	if target == null:
		printerr("CameraHandler: no target found")
		set_process(false)
	else:
		global_position = target.global_position
	
	camera.make_current()


func _process(delta : float) -> void:
	var next_pos := target.global_position
	if followed_nodes.size() > 0:
		var followed_node: Node2D = followed_nodes.back()
		if followed_node.has_method("get_next_position"):
			next_pos = followed_node.get_next_position(target.global_position)
		else:
			next_pos = followed_node.global_position
	
	if damping_timer > 0:
		var t = 1 - damping_timer / damp_time
		next_pos = lerp(damped_pos, next_pos, t)
		damping_timer -= delta
	
	global_position = next_pos
	
	if trauma.x > 0 or trauma.y > 0:
		trauma.x = max(trauma.x - decay * delta, 0)
		trauma.y = max(trauma.y - decay * delta, 0)
		shake()


func start_following_node(node : Node2D) -> void:
	start_damping()
	
	if node != null:
		followed_nodes.append(node)


func stop_following_node(node : Node2D) -> void:
	if followed_nodes.back() == node:
		start_damping()
	
	followed_nodes.erase(node)


func start_damping() -> void:
	if is_first_damp:
		is_first_damp = false
		return
	
	damping_timer = damp_time
	damped_pos = global_position


func add_trauma(x : float, y : float) -> void:
	trauma.x = min(trauma.x + x, 1.0)
	trauma.y = min(trauma.y + y, 1.0)


func shake() -> void:
	var amount = Vector2(pow(trauma.x, TRAUMA_POWER), pow(trauma.y, TRAUMA_POWER))
	noise_y += 1
	rotation = max_roll * max(amount.x, amount.y) * noise.get_noise_2d(noise.seed, noise_y)
	camera.offset.x = max_offset.x * amount.x * noise.get_noise_2d(noise.seed * 2, noise_y)
	camera.offset.y = max_offset.y * amount.y * noise.get_noise_2d(noise.seed * 3, noise_y)
