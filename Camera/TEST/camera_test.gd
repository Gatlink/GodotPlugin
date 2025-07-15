extends Node2D


func _ready() -> void:
	randomize()


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
