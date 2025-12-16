extends PlayerState

@export var timer: Timer
@export var jump_strength: int
@export var jump_time: int

signal fall
signal air_dash
signal fast_fall

func _ready() -> void:
	super()
	timer.wait_time = jump_time
	timer.timeout.connect(on_timer_timeout)

func enter_state():
	super()
	actor.velocity.y = jump_strength
	timer.start()

func _physics_process(delta: float) -> void:
	if not Input.is_action_pressed("move_jump"):
		fall.emit()
	if actor.velocity.y <= 0:
		fall.emit()
	if Input.is_action_pressed("move_dash"):
		air_dash.emit()
	if Input.is_action_pressed("move_fastfall"):
		fast_fall.emit()

func on_timer_timeout():
	fall.emit()
