@tool
class_name CameraPath
extends Area2D


@onready var handler: CameraHandler = get_tree().get_first_node_in_group("CameraHandler")
@onready var path: Path2D


func get_next_position(target : Node2D) -> Vector2:
	return to_global(path.curve.get_closest_point(to_local(target.global_position)))


func _get_configuration_warnings() -> PackedStringArray:
	for node in get_children():
		if node is Path2D:
			return []
	
	return ["Path2D is required for this component to work."]


func _ready() -> void:
	if handler == null:
		printerr("CameraPath could not find a CameraHandler")
		return
	
	for child in get_children():
		var child_path := child as Path2D
		if child_path != null:
			path = child_path
			return
	
	if not Engine.is_editor_hint():
		printerr("CameraPath requires a Path2D to function properly.")


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	if path == null or Engine.is_editor_hint():
		return
	
	for i in path.curve.point_count - 1:
		draw_line(
			path.curve.get_point_position(i),
			path.curve.get_point_position(i + 1),
			Color.RED
		)


func _on_Area2D_body_entered(_body: Node2D) -> void:
	handler.start_following_node(self)


func _on_Area2D_body_exited(_body: Node2D) -> void:
	handler.stop_following_node(self)
