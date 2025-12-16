extends CharacterBody3D

@export var mouse_sensitivity : float
@export var movement_speed: int
@export var max_movement_speed: int
@export var acceleration: float
@export var gravity: float

@export var idle_state: PlayerState
@export var jump_state: PlayerState
@export var fall_state: PlayerState
@export var land_state: PlayerState

@onready var camera = $TwistPivot/PitchPivot/Camera3D

@onready var anim_tree: AnimationTree = $keishi_2/AnimationTree
@onready var glide_machine = $keishi_2/AnimationTree.get("parameters/Glide_Machine/playback") as AnimationNodeStateMachinePlayback

enum {IDLE, RUN, GLIDE, FALL}
var cur_anim = IDLE


var twist_input := 0.0
var pitch_input := 0.0

const FRAME_TIME :=  0.17

var time_accumulator := 0.0
var last_animation := ""
var animation_position := 0.0

var movement_input := Vector3.ZERO

@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

var default_node_signals = ["ready", "renamed", "tree_entered", "tree_exiting", "tree_exited", "child_entered_tree", "child_exiting_tree", "child_order_changed", "replacing_by", "editor_description_changed", "editor_state_changed", "script_changed", "property_list_changed"]

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	idle_state.jump.connect(%StateMachine.change_state.bind(jump_state))
	idle_state.fall.connect(%StateMachine.change_state.bind(fall_state))
	
	jump_state.fall.connect(%StateMachine.change_state.bind(fall_state))
	
	fall_state.land.connect(%StateMachine.change_state.bind(land_state))
	
	land_state.idle.connect(%StateMachine.change_state.bind(idle_state))
	land_state.jump.connect(%StateMachine.change_state.bind(jump_state))
	land_state.fall.connect(%StateMachine.change_state.bind(fall_state))

var jump_button_released = false

func _process(delta: float) -> void:
	
	#MOVEMENT
	
	#Horizontal movement
	
	movement_input.x = Input.get_axis("move_left", "move_right")
	movement_input.z = Input.get_axis("move_foward", "move_back")
	
	var forward = %Camera3D.global_basis.z
	var right = %Camera3D.global_basis.x

	
	var movement_vector = (forward * movement_input.z) + (right * movement_input.x)
	
	movement_vector = movement_vector.rotated(Vector3.UP, pitch_pivot.rotation.y)
	

	
	#handles speeding up and slowing down in movement
	if movement_input:
		velocity.x = move_toward(velocity.x,movement_vector.x * max_movement_speed, acceleration)
		velocity.z = move_toward(velocity.z, movement_vector.z * max_movement_speed, acceleration)
	else:
		velocity.x = move_toward(velocity.x, 0, acceleration)
		velocity.z = move_toward(velocity.z, 0, acceleration)
	
	#Glide ability
	
	#var glide_speed = -2
	
	
	#if Input.is_action_pressed("move_jump") and not is_on_floor() and jump_button_released:
		#if velocity.y < glide_speed:
			#velocity.y = glide_speed
		#if Global.fanTime:
			#velocity.y = glide_speed * -25
			#if Global.fanRotation != 0.0:
				#velocity.x = Global.fanRotation * -1
		
	
	#if not Input.is_action_pressed("move_jump"):
		#jump_button_released = true
	
	#if is_on_floor():
		#jump_button_released = false
	
	
	#gravity
	if not is_on_floor():
		velocity.y -= gravity
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
	#CAMERA

	twist_pivot.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(pitch_pivot.rotation.x, 
		deg_to_rad(-60), 
		deg_to_rad(60)
	)
	twist_input = 0.0
	pitch_input = 0.0

	Global.player_position = global_position
	move_and_slide()
	


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
			$keishi_2/Armature/Skeleton3D/Cube.rotate_y(twist_input)

func _on_oob_body_entered(body: Node3D) -> void:
	get_tree().change_scene_to_file("res://scenes/placeholders/proto_land.tscn")
