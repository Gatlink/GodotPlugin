class_name CameraHandler
extends Node2D


@export (NodePath) var target_path : NodePath
@export (Vector2) var offset : Vector2
@export (float) var decay := 0.8
@export (Vector2) var max_offset := Vector2(100, 75)
@export (float) var max_roll := 0.1


const TRAUMA_POWER = 2


@onready var target : Node2D = get_node(target_path)
@onready var damping_timer : Timer = $DampingTimer
@onready var damp_time : float = damping_timer.wait_time
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
	noise.period = 4
	noise.fractal_octaves = 2
	camera.make_current()


func _process(delta : float) -> void:
	if current_node == null:
		return
	elif previous_node == null:
		position = get_next_position(current_node)
	else:
		var t = 1 - damping_timer.time_left / damp_time
		var previous_position = get_next_position(previous_node)
		var current_position = get_next_position(current_node)
		position = lerp(previous_position, current_position, t)
		
		if t >= 1:
			previous_node = null
	
	if trauma.x > 0 or trauma.y > 0:
		trauma.x = max(trauma.x - decay * delta, 0)
		trauma.y = max(trauma.y - decay * delta, 0)
		shake()


func _draw() -> void:
	pass
	# draw_circle(position, 5, Color.red)


func get_next_position(node : Node) -> Vector2:
	var path := node as CameraPath
	if path != null:
		return path.get_next_position(target) + offset
	
	var area := node as CameraArea
	if area != null:
		var limits := area.limits
		var position := target.global_position + offset
		var size := get_viewport_rect().size * 0.5
		var left_top_offset := limits.position - (position - size)
		var right_bottom_offset := limits.end - (position + size)
		
		left_top_offset.x = max(0, left_top_offset.x)
		left_top_offset.y = max(0, left_top_offset.y)
		right_bottom_offset.x = min(0, right_bottom_offset.x)
		right_bottom_offset.y = min(0, right_bottom_offset.y)
		
		return position + left_top_offset + right_bottom_offset
		
	
	if current_node != null:
		return current_node.global_position + offset
	
	return target.global_position + offset


func start_following_node(node : Node2D) -> void:
	previous_node = current_node
	current_node = node
	
	followed_nodes.push_front(node)
	
	# just to avoid an error when quitting the game
	if damping_timer.is_inside_tree():
		var time_left = damping_timer.time_left
		damping_timer.start(damp_time - time_left)


func stop_following_node(node : Node2D) -> void:
	var index := followed_nodes.find(node)
	followed_nodes.remove(index)
	if index == 0:
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
