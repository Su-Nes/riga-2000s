extends Node3D

class_name Interactable


@export var ITEM_NAME : String
@export var CONST_PATH : String

@export var MESH : MeshInstance3D
@export var COLLIDER : CollisionShape3D
@export var RIGIDBODY : RigidBody3D


func _ready() -> void:
	if MESH:
		return
	
	for n in get_children():
		if n is MeshInstance3D:
			MESH = n
			break

func on_focus():
	pass
	
func on_lose_focus():
	pass
	
func on_interact():
	pass
	
func on_interact_alt():
	pass
	
func on_selected():
	pass
	
func on_unselected():
	pass
	
func on_use() -> bool: ##Returns false if interactable is freed after interaction
	return true
	
func on_grabbed():
	pass
	
func on_dropped():
	pass
	
func on_save_data(saved_data: Array[SavedData]):
	var data = SavedData.new()
	
	var self_scene = PackedScene.new()
	self_scene.pack(self)
	
	var path : String = Constants.SCENE_PATHS[CONST_PATH] if CONST_PATH.length() > 0 else scene_file_path
	
	data.file_path = path
	data.tree_path = get_path()
	data.tf = transform
	data.parent_path = get_parent().get_path()
	
	saved_data.append(data)
	
func on_loaded(data: SavedData):
	transform = data.tf
