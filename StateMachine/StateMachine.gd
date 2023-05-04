class_name StateMachine
extends Node


@onready var state : State = get_child(0)


func _ready() -> void:
	await owner.ready
	
	for child in get_children():
		var child_state := child as State
		if child_state != null:
			child_state.state_machine = self
	
	state.enter()


func _process(delta : float) -> void:
	state.update(delta)


func _physics_process(delta : float) -> void:
	state.physics_update(delta)


func _unhandled_input(_event : InputEvent) -> void:
	state.handle_input(_event)


func transition_to(state_name : String, param : Dictionary = {}) -> void:
	if not has_node(state_name):
		printerr( "StateMachine: state " + state_name + " doesn't exists." )
		return
	
	state.exit()
	state = get_node(state_name)
	state.enter(param)
