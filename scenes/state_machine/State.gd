extends Node

export (NodePath) var NextState

var character
var state_machine

func enter_state(_character, _state_machine) -> void:
    character = _character
    state_machine = _state_machine
    
func exit_state() -> void:
    pass
