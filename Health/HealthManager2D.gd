class_name HealthManager2D
extends Area2D


@export_range(0, 100) var max_hp : int = 10
@export_range(0, 10) var invulnerability_duration : float


@onready var current_hp : int = max_hp


var timer : float


func _process(delta : float) -> void:
	timer -= delta
	
	if timer <= 0:
		set_process(false)


func is_dead() -> bool:
	return current_hp <= 0


func hit(damage : int = 1) -> void:
	if timer > 0:
		return
	
	if current_hp <= 0:
		return
	
	current_hp -= damage
	
	if is_dead():
		if owner.has_method("kill"):
			owner.kill()
		else:
			owner.queue_free()
		return
	elif owner.has_method("hit"):
		owner.hit()
	
	if invulnerability_duration > 0:
		timer = invulnerability_duration
		set_process(true)


func set_can_be_touched(can_be_touched : bool) -> void:
	for child in get_children():
		var shape := child as CollisionShape2D
		if shape != null:
			shape.disabled = not can_be_touched
