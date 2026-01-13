extends PlayerState

signal idle
signal fall
signal jump
signal walk

func _ready() -> void:
	super()
	animator.animation_finished.connect(on_animation_finished)

func enter_state():
	super()

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("move_jump"):
		jump.emit()

func on_animation_finished(anim_name):
	if anim_name == "Land":
		if not actor.is_on_floor():
			fall.emit()
		elif Input.is_action_just_pressed("move_jump"):
			jump.emit()
		elif not actor.movement_input == Vector3.ZERO:
			walk.emit()
		else:
			idle.emit()
