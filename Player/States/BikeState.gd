extends State

class_name BikeState


@export var MOVE_SPEED: float = 10
@export var GROUND_INERTIA = 14.0

@onready var player_controller: CharacterBody3D = $"../.."
@onready var collision_shape_3d: CollisionShape3D = $"../../CollisionShape3D"

var origin_parent: Node3D
var bike: BikeController

func _ready() -> void:
	origin_parent = player_controller.get_parent_node_3d()

func enter() -> void:
	bike = $"../../Interaction".current_interactable.owner
	bike.bike_enabled = true
	
	player_controller.reparent(bike.get_node("PlayerPivot")) 
	player_controller.transform = Transform3D.IDENTITY
	#state_machine.ANIMATOR.play("Walk")
	
func update(_delta: float):
	if Input.is_action_just_pressed("interact"):
		state_machine.change_state("idlestate")
		
func exit():
	player_controller.reparent(origin_parent)
	player_controller.global_position += bike.global_basis.x * 2
	player_controller.velocity = Vector3.ZERO
	
	bike.bike_enabled = false
