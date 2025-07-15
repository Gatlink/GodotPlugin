class_name CameraPoI
extends Area2D


@export_range(0.0, 1.0) var weight: float = 0.5


@onready var handler: CameraHandler = get_tree().get_first_node_in_group("CameraHandler")


func get_next_position(target : Node2D) -> Vector2:
	return lerp(target.global_position, global_position, weight)


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, 16, Color.RED)


func _on_body_entered(_body: Node2D) -> void:
	handler.start_following_node(self)


func _on_body_exited(_body: Node2D) -> void:
	handler.stop_following_node(self)
