extends "res://scenes/state_machine/DamageState.gd"

export (String, "Explosive", "Gun", "Blade", "Fist") var WeaponType

func handle_damage(weapon, from_direction : Vector2) -> void:
    if weapon.WeaponType == WeaponType:
        var amount = weapon.Damage
        if character.HP <= amount:
            character.dies()
        else:
            character.HP -= amount
            character.take_damage()
