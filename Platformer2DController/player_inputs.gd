extends Node


var dir := Vector2.ZERO


func _process(_delta: float) -> void:
	dir.x = Input.get_axis("left", "right")
