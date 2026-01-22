extends Area3D

@onready var blades = $Blades
@onready var fan_air = $Air



const rot_speed = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	blades.rotate_y(deg_to_rad(rot_speed))

func _on_body_entered(_body: Node3D) -> void:
	var air_rotation = fan_air.global_rotation_degrees
	if Input.is_action_pressed("move_jump"):
		Global.fanTime = true
		Global.fanRotation = Vector3(rotation.x, 1, rotation.z)


func _on_body_exited(_body: Node3D) -> void:
	Global.fanTime = false
