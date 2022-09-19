class_name StateMachine
extends Node


# STATE
class State:
	extends Node

	var state_machine : StateMachine


	func enter(_param : Dictionary = {}) -> void:
		pass


	func exit() -> void:
		pass


	func update(_delta : float) -> void:
		pass


	func physics_update(_delta : float) -> void:
		pass


	func handle_input(_event : InputEvent) -> void:
		pass


# STATE MACHINE
onready var state : State = get_child(0)

func _ready() -> void:
	yield(owner, "ready")
	
	for child in get_children():
		child.state_machine = self
	
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
