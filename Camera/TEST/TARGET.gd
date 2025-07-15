extends CharacterBody2D


@export var speed : float = 300.0


func _process(delta: float) -> void:
	var dir := Vector2(
		Input.get_axis("ui_left", "ui_right"),
		Input.get_axis("ui_up", "ui_down")
	)
	
	position += dir.normalized() * speed * delta


func _draw() -> void:
	draw_rect(Rect2(Vector2(-32, -32), Vector2(64, 64)), Color.RED)
