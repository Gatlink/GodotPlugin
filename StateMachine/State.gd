class_name State
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


func transition_to(state : String, param : Dictionary = {}) -> void:
	state_machine.transition_to(state, param)
