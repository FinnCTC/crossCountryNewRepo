extends State
class_name PlayerState

@export var animation_name: String

func _ready() -> void:
	super()
	actor = self.get_parent().get_parent()

func enter_state():
	super()
	if animation_name:
		animator.play(animation_name)
