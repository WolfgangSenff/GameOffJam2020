extends Node

var current_physics_state setget set_current_physics_state
var current_damage_state setget set_current_damage_state

func set_current_physics_state(value) -> void:
    var character = get_parent()
    
    if current_physics_state:
        current_physics_state.exit_state()
    
    current_physics_state = value
    current_physics_state.enter_state(character, self)
    
func set_current_damage_state(value) -> void:
    var character = get_parent()
    
    if current_damage_state:
        current_damage_state.exit_state()
    
    current_damage_state = value
    current_damage_state.enter_state(character, self)
