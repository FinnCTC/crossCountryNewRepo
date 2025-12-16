extends Node
class_name State

@export var actor: Node3D
@export var animator: AnimationPlayer

var in_state: bool

func _ready() -> void:
	in_state = false
	set_physics_process(false)

func enter_state():
	in_state = true
	set_physics_process(true)

func exit_state():
	in_state = false
	set_physics_process(false)
