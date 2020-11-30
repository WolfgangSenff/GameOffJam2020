extends "res://scenes/state_machine/PhysicsState.gd"

onready var navigator = $Navigator2D
var navigation

export (float) var TimeBetweenNewPositions
export (int) var TimesToWander

var current_time_to_new_position = 0.0
var current_wander_count = 0

func enter_state(_character, _state_machine) -> void:
    .enter_state(_character, _state_machine)
    navigation = get_tree().get_nodes_in_group("Navigation")[0]
    navigator.actor = _character
    navigator.navigation = navigation
    if not navigator.is_connected("on_moved", self, "on_character_moved"):
        navigator.connect("on_moved", self, "on_character_moved")
    if not navigator.is_connected("on_destination_reached", self, "on_character_reached_destination"):
        navigator.connect("on_destination_reached", self, "on_character_reached_destination")
    
    var new_wandering_position = navigation.get_random_wandering_position()
    current_wander_count = 1
    current_time_to_new_position = 0.0
    navigator.navigate_to(new_wandering_position)
    
func on_character_moved(direction) -> void:
    character.direction = direction
    
func handle_physics(delta: float) -> void:
    if !navigator.is_navigating:
        current_time_to_new_position += delta
        self.is_idle = true
        if current_time_to_new_position >= TimeBetweenNewPositions:
            if current_wander_count < TimesToWander or not NextState:
                navigator.navigate_to(navigation.get_random_wandering_position())
                current_wander_count += 1
                self.is_moving = true
            else:
                if has_node(NextState):
                    var next_state = get_node(NextState)
                    if next_state:
                        state_machine.current_physics_state = next_state
                        next_state.handle_physics(delta)
    else:
        self.is_moving = true
        current_time_to_new_position = 0.0

func on_character_reached_destination(nav, pos) -> void:
    self.is_idle = true
    yield(get_tree().create_timer(0.2), "timeout")
