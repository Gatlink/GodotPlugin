extends Node2D


@onready var camera := $CameraHandler
@onready var nodes := [
	$TARGET,
#	$CameraPath,
	$CameraArea
]


var current_node := 0


func _ready() -> void:
	randomize()
	camera.start_following_node(nodes[0])


func _draw() -> void:
	for i in 50:
		var rect := get_viewport_rect()
		var pos := Vector2(
			(randf() * 2 - 1) * rect.size.x * 1.5,
			(randf() * 2 - 1) * rect.size.y * 1.5
		)
		
		var color := Color(
			randf() * 0.4,
			randf() * 0.4,
			randf() * 0.4
		)
		
		draw_circle(pos, 50 + randf() * 50, color)


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		current_node = (current_node + 1) % nodes.size()
		camera.start_following_node(nodes[current_node])
