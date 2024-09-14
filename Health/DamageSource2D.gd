class_name DamageSource2D
extends Area2D


signal killed


@export_range(0, 100) var damage : int = 1


var collision_shapes : Array[CollisionShape2D] = []


func _ready():
	connect("area_entered", on_area_entered)
	
	for child in get_children():
		var shape := child as CollisionShape2D
		if shape != null:
			collision_shapes.append(shape)
	
	set_active(false)


func on_area_entered(area : Area2D) -> void:
	print("HIT")
	
	if area.owner == owner:
		return
	
	var health_manager := area as HealthManager2D
	if health_manager != null:
		apply_damage(health_manager)


func apply_damage(health_manager : HealthManager2D) -> void:
	health_manager.hit(damage)
		
	if health_manager.current_hp <= 0:
		emit_signal("killed")


func set_active(is_active : bool) -> void:
	for shape in collision_shapes:
		shape.disabled = not is_active
