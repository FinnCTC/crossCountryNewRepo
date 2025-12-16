extends Node

@export var starting_state: State

var current_state: State

func _ready() -> void:
	change_state(starting_state)

func _process(delta: float) -> void:
	pass

func change_state(new_state: State):
	if current_state:
		current_state.exit_state()
	new_state.enter_state()
	current_state = new_state
