extends Node


var game_complete : bool = false
const LABEL = preload(Constants.SCENE_PATHS.Label)
var label : Label

var autosave_interval : float = 60
var autosave_timer : float

func _ready() -> void:
	label = LABEL.instantiate()
	add_child(label)
	label.hide()
	
func _process(delta: float) -> void:
	autosave_timer += delta
	
	if autosave_timer > autosave_interval:
		save_game()
		autosave_timer = 0

func save_game():
	if get_tree().current_scene.name != "Main":
		return
	
	show_text()
	
	var saved_game = SavedGame.new()
	
	var player = get_tree().get_first_node_in_group("Player") as Node3D
	
	saved_game.player_position = player.global_position
	
	saved_game.game_complete = game_complete
	
	# save all persistant objects
	var saved_data : Array[SavedData]
	
	get_tree().call_group("Persistent", "on_save_data", saved_data)
	saved_game.saved_data = saved_data

	ResourceSaver.save(saved_game, Constants.SAVE_PATH)
	
func load_game():
	var saved_game : SavedGame = load(Constants.SAVE_PATH)
	
	get_tree().call_group("Persistent", "queue_free")

	var loaded_scene : PackedScene
	for data : SavedData in saved_game.saved_data:
		loaded_scene = load(data.file_path)
		
		var new_scene = loaded_scene.instantiate()
		new_scene.add_to_group("Persistent")
		
		if new_scene.has_method("on_loaded"):
			new_scene.on_loaded(data)
			
	load_player(saved_game)
			
func load_player(save: SavedGame):
	
	var player = get_tree().get_first_node_in_group("Player") as CharacterBody3D
	player.global_position = save.player_position
	
	player.velocity = Vector3.ZERO
	
func clear_save():
	var saved_game = SavedGame.new()
	
	saved_game.player_position = Vector3(0, 100, 0)
	
	ResourceSaver.save(saved_game, Constants.SAVE_PATH)
	
func show_text():
	label.show()
	await get_tree().create_timer(1).timeout
	label.hide()
