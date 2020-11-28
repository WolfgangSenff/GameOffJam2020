extends "res://scenes/state_machine/State.gd"

var is_idle setget set_is_idle
var is_moving setget set_is_moving
var is_attacking setget set_is_attacking

func handle_physics(delta : float) -> void:
    pass
    
func set_is_idle(value):
    is_idle = value
    if is_idle:
        is_moving = false
        is_attacking = false
    
func set_is_moving(value):
    is_moving = value
    if is_moving:
        is_idle = false
        is_attacking = false

func set_is_attacking(value):
    is_attacking = value
    if is_attacking:
        is_idle = false
        is_moving = false
