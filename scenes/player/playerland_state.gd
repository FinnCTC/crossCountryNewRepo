extends PlayerState

signal idle
signal fall
signal jump

func _ready() -> void:
	super()
	animator.animation_finished.connect(on_animation_finished)

func enter_state():
	super()

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_jump"):
		jump.emit()
	if actor.velocity.y < 0 and not actor.is_on_floor():
		fall.emit()

func on_animation_finished(anim_name):
	if anim_name == "Land":
		idle.emit()
