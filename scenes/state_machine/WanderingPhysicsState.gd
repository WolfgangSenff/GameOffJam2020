extends "res://scenes/state_machine/PhysicsState.gd"

onready var navigator = $Navigator2D
var navigation

export (float) var TimeBetweenNewPositions
var current_time_to_new_position = 0.0

func enter_state(_character, _state_machine) -> void:
    .enter_state(_character, _state_machine)
    navigation = get_tree().get_nodes_in_group("Navigation")[0]
    navigator.actor = _character
    navigator.navigation = navigation
    var new_wandering_position = navigation.get_random_wandering_position()
    navigator.navigate_to(new_wandering_position)
    
func handle_physics(delta: float) -> void:
    if !navigator.is_navigating:
        current_time_to_new_position += delta
        if current_time_to_new_position >= TimeBetweenNewPositions:
            navigator.navigate_to(navigation.get_random_wandering_position())
    else:
        current_time_to_new_position = 0.0
