extends PlayerState

signal land
signal fall

var glide_speed = -3

func _ready() -> void:
	super()
	animator.animation_finished.connect(on_animation_finished)

func enter_state():
	super()
	actor.velocity.y = glide_speed

func _physics_process(delta: float) -> void:
	if not Input.is_action_pressed("move_jump") or actor.is_on_floor():
		animator.play("Glide_END")
		
		
	if Global.fanTime:
		actor.velocity += Global.fanRotation
	else: 
		actor.velocity.y = move_toward(actor.velocity.y, -3, delta * 10)

func on_animation_finished(anim_name):
	if in_state:
		if anim_name == "Glide_START":
			animator.play("Glide")
		if anim_name == "Glide_END":
			if actor.is_on_floor():
				land.emit()
			else:
				fall.emit()
