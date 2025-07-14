class_name CameraArea
extends Area2D


@onready var handler: CameraHandler = get_tree().get_first_node_in_group("CameraHandler")


var limits : Rect2


func _ready() -> void:
	var collision_shape = $CollisionShape2D
	var rectangle = collision_shape.shape as RectangleShape2D
	limits.position = collision_shape.global_position - rectangle.size * 0.5
	limits.size = rectangle.size
	
	if handler == null:
		printerr("CameraPath could not find a CameraHandler")


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	var top_left := limits.position - global_position
	var top_right := Vector2(limits.end.x, limits.position.y) - global_position
	var bottom_left := Vector2(limits.position.x, limits.end.y) - global_position
	var bottom_right := limits.end - global_position
	
	draw_line(top_left, top_right, Color.RED)
	draw_line(top_right, bottom_right, Color.RED)
	draw_line(bottom_right, bottom_left, Color.RED)
	draw_line(bottom_left, top_left, Color.RED)


func _on_CameraArea_body_entered(_body: Node2D) -> void:
	handler.start_following_node(self)


func _on_CameraArea_body_exited(_body: Node2D) -> void:
	handler.stop_following_node(self)
