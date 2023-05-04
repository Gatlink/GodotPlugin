class_name CameraArea
extends Area2D


var limits : Rect2


func _ready() -> void:
	var collision_shape = $CollisionShape2D
	var rectangle = collision_shape.shape as RectangleShape2D
	limits.position = collision_shape.global_position - rectangle.size
	limits.size = rectangle.size * 2
