extends PlayerState

signal walk
signal jump
signal fall

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_jump"):
		jump.emit()
	if actor.movement_input != Vector3.ZERO:
		walk.emit()
	if actor.velocity.y < 0:
		fall.emit()
