extends PlayerState

signal land

func enter_state():
	super()
	actor.velocity.y /= 3

func _physics_process(delta: float) -> void:
	actor.velocity.y -= 0.1

	if actor.is_on_floor():
		land.emit()
