extends Node


@onready var camera : Camera2D = get_viewport().get_camera_2d()

var shake_tween : Tween
var shake_priority : int


func freeze(duration : float = 0.2) -> void:
	Engine.time_scale = 0.1
	
	await get_tree().create_timer(duration * Engine.time_scale).timeout
	
	Engine.time_scale = 1.0


func screen_shake(amplitude := Vector2(16, 16), freq : float = 15.0, duration : float = 0.2, priority : int = 0) -> void:
	if shake_tween != null and priority >= shake_priority:
		shake_tween.kill()
	
	shake_tween = create_tween()
	shake_priority = priority
	
	var step := duration / freq
	for i in freq:
		var target_offset := Vector2(
			randf_range(-1.0, 1.0) * amplitude.x,
			randf_range(-1.0, 1.0) * amplitude.y
		)
		shake_tween.tween_property(camera, "offset", target_offset, step) \
			.set_ease(Tween.EASE_IN_OUT) \
			.set_trans(Tween.TRANS_SINE)
	
	shake_tween.tween_property(camera, "offset", Vector2.ZERO, 0.2)
