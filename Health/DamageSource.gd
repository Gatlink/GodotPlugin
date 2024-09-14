class_name DamageSource
extends Area3D


signal killed


@export_range(0, 100) var damage : int = 1


var collision_shapes : Array[CollisionShape3D] = []


func _ready():
	connect("area_entered", on_area_entered)
	
	for child in get_children():
		var shape := child as CollisionShape3D
		if shape != null:
			collision_shapes.append(shape)
	
	set_active(false)


func on_area_entered(area : Area3D) -> void:
	if area.owner == owner:
		return
	
	var health_manager := area as HealthManager
	if health_manager != null:
		apply_damage(health_manager)


func apply_damage(health_manager : HealthManager) -> void:
	health_manager.hit(damage)
		
	if health_manager.current_hp <= 0:
		emit_signal("killed")


func set_active(is_active : bool) -> void:
	for shape in collision_shapes:
		shape.disabled = not is_active
