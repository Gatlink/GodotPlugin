class_name CameraPath
extends Path2D


@onready var handler: CameraHandler = get_tree().get_first_node_in_group("CameraHandler")


func get_next_position(target : Node2D) -> Vector2:
	return curve.get_closest_point(to_local(target.global_position))


func _ready() -> void:
	if handler == null:
		printerr("CameraPath could not find a CameraHandler")


func _on_Area2D_body_entered(_body: Node2D) -> void:
	handler.start_following_node(self)


func _on_Area2D_body_exited(_body: Node2D) -> void:
	handler.stop_following_node(self)
