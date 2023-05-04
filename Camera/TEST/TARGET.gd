extends Area2D


@export (float) var speed : float = 200.0


@onready var camera_handler : CameraHandler = get_node("../CameraHandler")


func _process(delta: float) -> void:
	var dir := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	
	position += dir.normalized() * speed * delta


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, Vector2(50, 50)), Color.RED)
