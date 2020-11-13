extends "res://scenes/state_machine/DamageState.gd"

export (int) onready var ArmorAmount

var current_armor

onready var armor_sprite = $Sprite

func _ready() -> void:
    current_armor = ArmorAmount

func handle_damage(weapon, from_direction : Vector2) -> void:
    var weapon_type = weapon.WeaponType
    var amount = weapon.Damage
    
    if current_armor > 0:
        if weapon_type == Weapon.Explosive:
            character.HP -= amount # Armor doesn't help against explosive damage
            current_armor -= 5.0 # It also takes a terrible toll on it
        elif weapon_type == Weapon.Gun:
            character.HP -= amount / 2.0
            current_armor -= 3.0
        elif weapon_type == Weapon.Blade:
            character.HP -= amount / 3.0
            current_armor -= 2.0
        elif weapon_type == Weapon.Fist:
            character.HP -= amount / 4.0
            current_armor -= 1.0
        
        armor_sprite.global_position = character.global_position
        var normalized_direction = from_direction.normalized()
        var normalized_angle = rad2deg(normalized_direction.angle())
        armor_sprite.scale.x = 1 if (normalized_angle >= 90 or normalized_angle <= -90) else -1
        armor_sprite.global_position -= Vector2(armor_sprite.scale.x * armor_sprite.texture.get_width() + 10.0, 0.0)
        armor_sprite.show()
        if weapon_type == Weapon.Gun:
            weapon.queue_free()
        yield(get_tree().create_timer(0.2), "timeout")
        armor_sprite.hide()
    elif NextState:
        var next_state = get_node(NextState)
        if next_state:
            state_machine.current_damage_state = next_state
            next_state.handle_damage(weapon, from_direction)
    else:
        character.HP -= amount
        if character.HP <= 0:
            character.dies()
    
