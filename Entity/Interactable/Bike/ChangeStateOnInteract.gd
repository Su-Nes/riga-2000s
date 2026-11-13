extends Interactable

class_name ChangeStateOnInteract


@export var NEW_STATE: String

func on_interact():
	Signals.player_change_state.emit(NEW_STATE)
