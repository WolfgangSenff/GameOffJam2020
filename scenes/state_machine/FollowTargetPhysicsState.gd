extends "res://scenes/state_machine/PhysicsState.gd"

var target = null
var navigation
var current_time_to_new_position = 0.0

export (float) onready var TimeBetweenNewPositions = 0.9
export (float) onready var MovementSpeed

onready var navigator = $Navigator2D

func enter_state(_character, _state_machine) -> void:
    .enter_state(_character, _state_machine)
    navigation = get_tree().get_nodes_in_group("Navigation")[0]
    navigator.actor = _character
    navigator.navigation = navigation
    navigator.Speed = MovementSpeed
    if not navigator.is_connected("on_moved", self, "on_character_moved"):
        navigator.connect("on_moved", self, "on_character_moved")
    if target:
        navigator.navigate_to(target.position)

func on_character_moved(direction) -> void:
    character.direction = direction

func handle_physics(delta: float) -> void:
    if !navigator.is_navigating and target:
        self.is_attacking = true
        current_time_to_new_position += delta
        if current_time_to_new_position >= TimeBetweenNewPositions:
            navigator.navigate_to(target.position)
        else:
            yield(get_tree(), "physics_frame")
            self.is_idle = true
    else:
        current_time_to_new_position = 0.0
        self.is_moving = true
