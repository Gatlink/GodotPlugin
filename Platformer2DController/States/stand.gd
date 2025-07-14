class_name PlayerStand
extends PlayerMove


func physics_update(delta: float) -> void:
	super(delta)
	
	if not player.is_on_floor():
		transition_to("Air")
	elif Input.is_action_just_pressed("jump"):
		transition_to("Jump")
