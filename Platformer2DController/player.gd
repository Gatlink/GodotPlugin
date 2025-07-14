class_name Player
extends CharacterBody2D


const POSITION_BUFFER_COUNT: int = 1024 


@export var debug_draw: bool


@onready var graph: Node2D = $Graph


var position_buffer: Array[Vector2] = []


var dir: float:
	set(value):
		if value == 0:
			return
		
		dir = value
		graph.scale.x = value
	get:
		return graph.scale.x


func _ready() -> void:
	position_buffer.append(global_position)


func _process(_delta: float) -> void:
	queue_redraw()


func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	position_buffer.append(global_position)
	
	if position_buffer.size() >= POSITION_BUFFER_COUNT:
		position_buffer.remove_at(0)


func _draw() -> void:
	for i in range(0, position_buffer.size() - 2):
		draw_line(position_buffer[i] - global_position, position_buffer[i + 1] - global_position, Color.FIREBRICK)
