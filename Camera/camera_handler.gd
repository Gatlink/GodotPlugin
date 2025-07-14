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


var previous_node : Node2D
var current_node : Node2D
var followed_nodes : Array = []
var trauma : Vector2
var noise_y : int = 0


func _ready() -> void:
	randomize()
	noise.seed = randi()
	noise.fractal_octaves = 2
	camera.make_current()
	
	if target == null:
		printerr("CameraHandler: no target found")
		set_process(false)
	else:
		global_position = target.global_position


func _process(delta : float) -> void:
	if current_node == null:
		return
	elif previous_node == null:
		position = get_next_position(current_node)
	else:
		var t = 1 - damping_timer / damp_time
		var previous_position = get_next_position(previous_node)
		var current_position = get_next_position(current_node)
		global_position = lerp(previous_position, current_position, t)
		
		damping_timer -= delta
		if damping_timer <= 0:
			previous_node = null
	
	if trauma.x > 0 or trauma.y > 0:
		trauma.x = max(trauma.x - decay * delta, 0)
		trauma.y = max(trauma.y - decay * delta, 0)
		shake()


func get_next_position(node : Node) -> Vector2:
	var path := node as CameraPath
	if path != null:
		return path.get_next_position(target)
	
	var area := node as CameraArea
	if area != null:
		var limits := area.limits
		var pos := target.global_position
		var size := get_viewport_rect().size * 0.5
		var left_top_offset := limits.position - (pos - size)
		var right_bottom_offset := limits.end - (pos + size)
		
		left_top_offset.x = max(0, left_top_offset.x)
		left_top_offset.y = max(0, left_top_offset.y)
		right_bottom_offset.x = min(0, right_bottom_offset.x)
		right_bottom_offset.y = min(0, right_bottom_offset.y)
		
		return pos + left_top_offset + right_bottom_offset
	
	if current_node != null:
		return current_node.global_position
	
	return target.global_position


func start_following_node(node : Node2D) -> void:
	previous_node = current_node
	current_node = node
	followed_nodes.push_front(node)
	damping_timer = damp_time


func stop_following_node(node : Node2D) -> void:
	followed_nodes.erase(node)
	start_following_node(followed_nodes[0] if followed_nodes.size() > 0 else null)


func add_trauma(x : float, y : float) -> void:
	trauma.x = min(trauma.x + x, 1.0)
	trauma.y = min(trauma.y + y, 1.0)


func shake() -> void:
	var amount = Vector2(pow(trauma.x, TRAUMA_POWER), pow(trauma.y, TRAUMA_POWER))
	noise_y += 1
	rotation = max_roll * max(amount.x, amount.y) * noise.get_noise_2d(noise.seed, noise_y)
	camera.offset.x = max_offset.x * amount.x * noise.get_noise_2d(noise.seed * 2, noise_y)
	camera.offset.y = max_offset.y * amount.y * noise.get_noise_2d(noise.seed * 3, noise_y)
