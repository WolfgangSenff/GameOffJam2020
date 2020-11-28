extends "res://scenes/state_machine/DamageState.gd"

func handle_damage(weapon, from_direction : Vector2) -> void:
    var amount = weapon.Damage
    if character.HP <= amount:
        character.dies()
    else:
        character.HP -= amount
        character.take_damage()
