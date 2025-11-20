extends CharacterBody3D

@export var speed: int

var target_velocity := Vector3.ZERO

# Called when the node enters the scene tree for the first time.	
func _ready() -> void:
	%NavTimer.timeout.connect(_on_nav_timer_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	Global.debug_value = velocity
	velocity = target_velocity
	
	move_and_slide()

func _on_nav_timer_timeout():
	%NavigationAgent3D.target_position = Global.player_position
	var current_location = global_transform.origin
	var target_location = %NavigationAgent3D.get_next_path_position()
	target_velocity = (target_location - current_location).normalized() * speed
