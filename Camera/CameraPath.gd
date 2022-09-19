tool
class_name CameraPath
extends Path2D


onready var follow := $PathFollow2D


func _draw() -> void:
	if Engine.editor_hint:
		var size = get_viewport_rect().size
		var offset = $PathFollow2D.offset
		var rect = Rect2(curve.interpolate_baked(offset) - 0.5 * size, size)
		draw_rect(rect, Color.red, false, 3)


func get_next_position(target : Node2D) -> Vector2:
	return curve.get_closest_point(to_local(target.global_position))
