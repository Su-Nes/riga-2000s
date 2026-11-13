extends ShapeCast3D

class_name Interaction


@onready var interaction_icon: Control = $InteractionIcon

var current_interactable : Interactable
var camera: Camera3D

func _ready() -> void:
	camera = owner.get_node("%MainCamera3D")
	
func _process(_delta: float) -> void:
	if !current_interactable:
		interaction_icon.hide()
		return
		
	interaction_icon.show()
	interaction_icon.set_position(camera.unproject_position(current_interactable.global_position))
	
	if Input.is_action_just_pressed("interact"):
		current_interactable.on_interact()
	

func _physics_process(_delta: float) -> void:
	if !is_colliding():
		current_interactable = null
		return
	elif current_interactable:
		return
	
	for n in get_collision_count():
		if get_collider(n) is not Interactable:
			continue
		
		var collider : Interactable = get_collider(n)
		
		if !current_interactable:
			current_interactable = collider
			continue
		
		if collider.global_position.distance_to(get_parent_node_3d().global_position) < current_interactable.global_position.distance_to(get_parent_node_3d().global_position):
			current_interactable = collider
