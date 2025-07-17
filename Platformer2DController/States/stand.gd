class_name PlayerStand
extends PlayerMove


func physics_update(delta: float) -> void:
	super(delta)
	
	player.play_animation("idle" if player.velocity == Vector2.ZERO else "run")
	
	if not player.is_on_floor():
		transition_to("Air")
	elif PlayerInputs.jumped:
		transition_to("Air", { "jump": true })
