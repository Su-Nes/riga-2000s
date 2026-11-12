extends State

class_name WalkState


@export var MOVE_SPEED: float = 10
@export var GROUND_INERTIA = 14.0

@onready var player_controller: CharacterBody3D = $"../.."
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"

var camera: Camera3D
var direction: Vector3
var velocity

func _ready() -> void:
	camera = owner.get_node("%MainCamera3D")

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
		
	# Switch to run state
	if Input.is_action_just_pressed("run"):
		state_machine.change_state("runstate")
	
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = ( Vector3(input_dir.x, 0, input_dir.y).rotated(Vector3.UP, camera.rotation.y)).normalized()

	# Switch to idle when no movement direction is held.
	if direction.length() <= 0.0:
		state_machine.change_state("idlestate")
		
func physics_update(delta: float):
	player_controller.velocity.x = lerp(player_controller.velocity.x, direction.x * MOVE_SPEED, delta * GROUND_INERTIA)
	player_controller.velocity.z = lerp(player_controller.velocity.z, direction.z * MOVE_SPEED, delta * GROUND_INERTIA)
	
	player_controller.transform = player_controller.transform.looking_at(player_controller.position + player_controller.velocity * 99)
	
	player_controller.move_and_slide()
