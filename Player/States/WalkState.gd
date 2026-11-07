extends State

class_name WalkState


@export var MOVE_SPEED: float = 10
@export var GROUND_INERTIA = 14.0
@export var MOMENTUM_DECAY = 1.0

@onready var player_controller: CharacterBody3D = $"../.."
@onready var camera_pivot_y: Node3D = $"../../Camera3D"
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"

var direction
var velocity

#func enter() -> void:
	#state_machine.ANIMATOR.play("Walk")
	
func update(_delta: float):
	# Switch to fall state if player controller is not on ground.
	if !player_controller.is_on_floor():
		state_machine.change_state("fallstate")
	
	# Switch to jump state
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state("jumpstate")
		return
		
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (camera_pivot_y.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Switch to idle when no movement direction is held.
	if direction.length() <= 0.0:
		state_machine.change_state("idlestate")
		
func physics_update(_delta: float):
	handle_velocity(_delta)

func handle_velocity(delta):
	player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * MOVE_SPEED, delta * GROUND_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * MOVE_SPEED, delta * GROUND_INERTIA)
	
	player_controller.move_and_slide()
