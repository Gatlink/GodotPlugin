class_name Player
extends CharacterBody2D


@onready var graph: Node2D = $Graph


var dir: float:
	set(value):
		if value == 0:
			return
		
		dir = value
		graph.scale.x = value
	get:
		return graph.scale.x


func _physics_process(_delta: float) -> void:
	move_and_slide()
