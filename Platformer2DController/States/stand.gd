class_name PlayerStand
extends PlayerMove


func physics_update(delta: float) -> void:
	super(delta)
	
	if not player.is_on_floor():
		transition_to("Air")
	elif PlayerInputs.jumped:
		transition_to("Air", { "jump": true })
