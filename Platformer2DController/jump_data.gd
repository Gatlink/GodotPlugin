class_name JumpData
extends Resource


## Unique identifier
@export var id: String

## Maximum height of the jump, in pixels
@export var max_height: float = 192.0

## Gravity while jumping
@export var gravity: float = 512.0

## Applied to gravity if the jump button is released early
@export var cutoff: float = 2.0

## Horizontal velocity applied at the start of the jump, in pixels/seconds
@export var initial_h_speed: float = 0.0

## Lock dir input during the jump
@export var is_dir_frozen: bool = false
