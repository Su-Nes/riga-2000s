extends Node

signal player_change_state(state: String)
signal player_changed_state(state: String)

func _ready() -> void:
	player_changed_state.has_connections()
	player_change_state.has_connections()
