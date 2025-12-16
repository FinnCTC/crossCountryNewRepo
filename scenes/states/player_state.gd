extends State
class_name PlayerState

@export var anim_name: String

func _ready() -> void:
	super()
	actor = self.get_parent().get_parent()

func enter_state():
	super()
	if anim_name:
		animator.play(anim_name)
