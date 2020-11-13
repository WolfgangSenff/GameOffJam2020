extends Node2D

onready var current_weapon setget set_current_weapon
var current_weapon_index = 0

var children = []

const SwapTimeoutTime = 1.5
var current_swap_timeout = 0.0
var is_in_timeout = true

func _ready() -> void:
    children = get_children()
    self.current_weapon = children[0]

func _physics_process(delta: float) -> void:
    if is_in_timeout:
        current_swap_timeout += delta
        if current_swap_timeout >= SwapTimeoutTime:
            is_in_timeout = false
            current_swap_timeout = 0.0
            
    if not is_in_timeout and Input.is_action_just_pressed("ui_swap_weapons"):
        current_weapon_index += 1
        current_weapon_index %= children.size()
        self.current_weapon = children[current_weapon_index]

func set_current_weapon(value) -> void:
    var was_idle = false
    if current_weapon:
        current_weapon.hide()
        was_idle = current_weapon.is_idle()
        
    current_weapon = value
    current_weapon.show()
    current_weapon.activate_weapon()
    if was_idle:
        current_weapon.go_idle()
