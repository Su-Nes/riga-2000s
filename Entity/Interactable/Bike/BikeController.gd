extends VehicleBody3D

class_name BikeController


@export var HANDLE: MeshInstance3D
@export var MAX_SPEED: float = 300
@export var REVERSE_SPEED: float = 400
@export var BRAKE_FORCE: float = 100
@export var MAX_TURN: float = .8
@export var TURN_SPEED: float = 4

var bike_enabled = false

func enable_bike(state: bool):
	bike_enabled = state
	
func _physics_process(delta: float) -> void:
	if !bike_enabled:
		return
	
	steering = lerp(steering, -Input.get_axis("left", "right") * MAX_TURN, delta * TURN_SPEED)

	if Input.is_action_pressed("forward"):
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = clampf(MAX_SPEED * 5.0 / speed, 0.0, 1000)
		else:
			engine_force = MAX_SPEED
		
		engine_force *= Input.get_action_strength("forward")
	else:
		engine_force = 0
		
	if Input.is_action_pressed("backward"):
		# Increase engine force at low speeds to make the initial reversing faster.
		var speed := linear_velocity.length()
		if speed < 5.0 and not is_zero_approx(speed):
			engine_force = -clampf(REVERSE_SPEED * 5.0 / speed, 0.0, 1000.0)
		else:
			engine_force = -REVERSE_SPEED

		# Apply analog brake factor for more subtle braking if not fully holding down the trigger.
		engine_force *= Input.get_action_strength("backward")
	
