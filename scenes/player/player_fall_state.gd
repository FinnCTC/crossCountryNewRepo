extends PlayerState

signal land
signal glide

@export var fall_speed: float

func enter_state():
	super()
	actor.velocity.y /= 3

func _physics_process(delta: float) -> void:
	actor.velocity.y -= fall_speed * delta
	if Input.is_action_just_pressed("move_jump"):
		glide.emit()

	if actor.is_on_floor():
		land.emit()
