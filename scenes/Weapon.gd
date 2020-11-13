class_name Weapon
extends Node2D

const Explosive = "Explosive"
const Gun = "Gun"
const Fist = "Fist"
const Blade = "Blade"

func activate_weapon() -> void:
    pass
    
func deactivate_weapon() -> void:
    pass
    
func main_activation(_velocity : Vector2 = Vector2(0, 0)) -> void:
    pass

func secondary_activation(_velocity : Vector2 = Vector2(0, 0)) -> void:
    pass
    
func reset_weapon() -> void:
    pass
    
func go_idle() -> void:
    pass
    
func is_idle() -> bool:
    return false


