extends "res://scenes/state_machine/DamageState.gd"

export (float) var Timeout

var is_invincible = false

func enter_state(_character, _state_machine) -> void:
    .enter_state(_character, _state_machine)
    is_invincible = false

func handle_damage(weapon, from_direction : Vector2) -> void:
    var amount = weapon.Damage
    if !is_invincible:
        if character.HP <= amount:
            character.dies()
            return
        else:
            is_invincible = true
            character.HP -= amount
            if weapon.WeaponType == Weapon.Gun:
                weapon.queue_free()
            
        character.begin_flashing()
        yield(get_tree().create_timer(Timeout), "timeout")
        character.stop_flashing()
        is_invincible = false
